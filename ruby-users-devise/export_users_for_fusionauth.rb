#!/usr/bin/env ruby

# Simple User Export Script for Devise Users
# Exports users as plain JSON

require_relative 'config/environment'
require 'json'
require 'securerandom'

puts "Starting user export for Devise users..."
puts "Found #{User.count} users to export"

users_data = User.all.map do |user|
  puts "Exporting user: #{user.email}"
  
  # Extract bcrypt cost factor for FusionAuth
  bcrypt_cost = nil
  if user.encrypted_password&.start_with?('$2a$')
    bcrypt_cost = user.encrypted_password.split('$')[2].to_i
  end
  
  user_data = {
    email: user.email,
    username: user.email,
    password: user.encrypted_password,
    encryptionScheme: "bcrypt",
    salt: "",
    verified: user.respond_to?(:confirmed?) ? user.confirmed? : true,
    active: true,
    registrations: [
      {
        id: SecureRandom.uuid,
        applicationId: "946a6b97-a9d1-4065-951a-0ef7dd5c281a",
        verified: user.respond_to?(:confirmed?) ? user.confirmed? : true,
        roles: ["user"]
      }
    ],
    data: {
      source_system: "devise",
      original_user_id: user.id,
      locked_at: user.respond_to?(:locked_at) ? user.locked_at : nil,
      confirmation_token: user.respond_to?(:confirmation_token) ? user.confirmation_token : nil,
      last_sign_in_ip: user.respond_to?(:last_sign_in_ip) ? user.last_sign_in_ip : nil,
      current_sign_in_ip: user.respond_to?(:current_sign_in_ip) ? user.current_sign_in_ip : nil
    }
  }
  
  # Add factor if bcrypt cost is available
  user_data[:factor] = bcrypt_cost if bcrypt_cost
  
  user_data
end

# Write to file with proper FusionAuth format
export_data = { users: users_data }
filename = "users_export_#{Time.current.strftime('%Y%m%d_%H%M%S')}.json"
File.write(filename, JSON.pretty_generate(export_data))

puts ""
puts "Export completed successfully!"
puts "File saved as: #{filename}"
puts "Total users exported: #{users_data.count}" 