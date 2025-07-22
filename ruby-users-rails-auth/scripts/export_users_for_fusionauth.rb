#!/usr/bin/env ruby

# Simple User Export Script for Rails Authentication
# Exports users as plain JSON

require_relative '../config/environment'
require 'json'
require 'securerandom'

puts "Starting user export for Rails Authentication users..."
puts "Found #{User.count} users to export"

users_data = User.all.map do |user|
  puts "Exporting user: #{user.email}"
  
  # Parse bcrypt hash according to FusionAuth requirements:
  # Example: $2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy
  # Should be split to:
  # factor: 10
  # salt: N9qo8uLOickgx2ZMRZoMye (first 22 chars after factor)
  # password: IjZAgcfl7p92ldGxad68LJZdL17lhWy (remaining chars)
  
  bcrypt_factor = 10  # default
  bcrypt_salt = ""
  bcrypt_password = ""
  
  if user.password_digest&.match(/^\$2[aby]\$(\d+)\$(.+)$/)
    bcrypt_factor = $1.to_i
    salt_and_hash = $2
    
    # According to the user, salt is first 22 characters
    bcrypt_salt = salt_and_hash[0, 22]
    # Password is the remaining characters
    bcrypt_password = salt_and_hash[22..-1]
  end
  
  user_data = {
    email: user.email,
    username: user.email,
    fullName: user.name,
    password: bcrypt_password,
    encryptionScheme: "bcrypt",
    factor: bcrypt_factor,
    salt: bcrypt_salt,
    passwordChangeRequired: false,  # Add this field like in Akamai example
    verified: user.confirmed?,
    active: user.confirmed?,
    registrations: [
      {
        id: SecureRandom.uuid,
        applicationId: "ae9e7a36-a8a7-44da-a340-34ebf08c2966",
        verified: user.confirmed?,
        roles: ["user"]
      }
    ],
    # Additional user data
    data: {
      migrated_from: "rails_authentication",
      original_id: user.id
    }
  }
  
  user_data
end

# Save to JSON file
timestamp = Time.now.strftime("%Y%m%d_%H%M%S")
filename = "users_export_#{timestamp}.json"

File.open(filename, 'w') do |file|
  file.write(JSON.pretty_generate(users_data))
end

puts "\nExport complete!"
puts "Saved #{users_data.length} users to #{filename}"
puts "\nExample import command:"
puts "./import.rb -k YOUR_API_KEY -t TENANT_ID -r APPLICATION_ID -u #{filename}" 