class FusionAuthConnectorController < ApplicationController
  # Skip CSRF protection for API endpoint called by FusionAuth
  skip_before_action :verify_authenticity_token
  
  APPLICATION_ID = 'e9fdb985-9173-4e01-9d73-ac2d60d1dc8e'.freeze
  
  def authenticate
    Rails.logger.info "FusionAuth connector request received for #{params[:loginId]}"
    
    email = params[:loginId]
    password = params[:password]
    
    # Validate required parameters
    if email.blank? || password.blank?
      Rails.logger.warn "Missing loginId or password in FusionAuth connector request"
      return head :bad_request
    end
    
    # Find user by email
    user = User.find_by(email: email.downcase)
    
    if user && authenticate_omniauth_user(user, password)
      Rails.logger.info "User authentication successful for #{email}. Returning user data to FusionAuth"
      
      user_data = build_fusionauth_user(user, password)
      Rails.logger.debug "Returning user data: #{user_data.inspect}"
      
      render json: { user: user_data }
    else
      Rails.logger.warn "Authentication failed for #{email}"
      head :not_found # 404 as required by FusionAuth for invalid credentials
    end
  rescue StandardError => e
    Rails.logger.error "Error in FusionAuth connector: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    head :internal_server_error
  end
  
  private
  
  def authenticate_omniauth_user(user, password)
    # Special authentication for OmniAuth users
    # Since they don't have passwords, we use a combination of strategies:
    
    # Strategy 1: Check if password matches "provider:uid" format (for migration)
    expected_auth_string = "#{user.provider}:#{user.uid}"
    return true if password == expected_auth_string
    
    # Strategy 2: Check if password is a temporary migration password based on user data
    migration_password = generate_migration_password(user)
    return true if password == migration_password
    
    # Strategy 3: For development/testing, allow a generic password
    return true if Rails.env.development? && password == "omniauth_migration_password"
    
    false
  end
  
  def generate_migration_password(user)
    # Generate a consistent migration password based on user attributes
    # This can be shared with users during migration process
    require 'digest/sha256'
    base_string = "#{user.provider}_#{user.uid}_#{user.email}_migration"
    Digest::SHA256.hexdigest(base_string)[0..15] # First 16 characters
  end
  
  def build_fusionauth_user(user, password)
    # Generate consistent UUID based on user ID
    user_uuid = generate_consistent_uuid(user.id)
    
    {
      # Required fields for FusionAuth
      id: user_uuid,
      email: user.email,
      username: user.email,
      
      # Authentication fields - generate a new password for FusionAuth
      password: generate_fusionauth_password(user),
      passwordChangeRequired: true, # Force password change since this is a migration
      
      # User profile fields
      fullName: user.display_name,
      firstName: extract_first_name(user.display_name),
      lastName: extract_last_name(user.display_name),
      imageUrl: user.image_url,
      verified: user.active?, # Use active status as verified
      active: user.active?,
      
      # Application registration - associate user with the application
      registrations: [{
        id: SecureRandom.uuid,
        applicationId: APPLICATION_ID,
        verified: user.active?,
        roles: ['user']
      }],
      
      # Migration metadata stored in user data
      data: {
        migrated_from: 'omniauth_authentication',
        original_id: user.id,
        migrated_at: Time.current.iso8601,
        provider: user.provider,
        uid: user.uid,
        original_image_url: user.image_url,
        provider_profile_url: user.provider_profile_url,
        raw_info: user.raw_info_json,
        created_at: user.created_at&.iso8601,
        updated_at: user.updated_at&.iso8601,
        migration_note: "User migrated from #{user.provider_name} OAuth login"
      }
    }
  end
  
  def generate_fusionauth_password(user)
    # Generate a secure random password for the migrated user
    # User will be required to change this on first login
    require 'securerandom'
    SecureRandom.alphanumeric(16) + "!"
  end
  
  def generate_consistent_uuid(user_id)
    # Generate a consistent UUID based on user ID
    namespace_uuid = '550e8400-e29b-41d4-a716-446655440001' # Different namespace for OmniAuth
    data = "omniauth_user_#{user_id}"
    
    # Create a deterministic UUID using SHA-1 hash (UUID v5)
    require 'digest/sha1'
    hash = Digest::SHA1.digest("#{namespace_uuid}#{data}")
    
    # Format as UUID v5
    hash_hex = hash.unpack1('H*')
    uuid = "#{hash_hex[0..7]}-#{hash_hex[8..11]}-5#{hash_hex[13..15]}-#{(hash_hex[16].to_i(16) & 0x3 | 0x8).to_s(16)}#{hash_hex[17..19]}-#{hash_hex[20..31]}"
    uuid
  end
  
  def extract_first_name(full_name)
    return '' if full_name.blank?
    full_name.split(' ').first
  end
  
  def extract_last_name(full_name)
    return '' if full_name.blank?
    parts = full_name.split(' ')
    return '' if parts.length < 2
    parts[1..-1].join(' ')
  end
end 