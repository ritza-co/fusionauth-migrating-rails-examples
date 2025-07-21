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
  
  # Extract bcrypt cost factor for FusionAuth
  bcrypt_cost = nil
  if user.password_digest&.start_with?('$2a$')
    bcrypt_cost = user.password_digest.split('$')[2].to_i
  end
  
  user_data = {
    email: user.email,
    username: user.email,
    fullName: user.name,
    password: user.password_digest,
    encryptionScheme: "bcrypt",
    salt: "",
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
    data: {
      source_system: "rails_auth",
      original_user_id: user.id,
      locked_at: nil,
      confirmation_token: nil,
      last_sign_in_ip: user.last_sign_in_ip,
      current_sign_in_ip: user.current_sign_in_ip
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
puts "Confirmed users: #{users_data.count { |u| u[:verified] }}" 