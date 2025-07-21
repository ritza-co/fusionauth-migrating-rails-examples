#!/usr/bin/env ruby

# Simple User Export Script for OmniAuth Users
# Exports users as plain JSON

require_relative 'config/environment'
require 'json'
require 'securerandom'

puts "Starting user export for OmniAuth users..."
puts "Found #{User.count} users to export"

users_data = User.all.map do |user|
  puts "Exporting user: #{user.email} (#{user.provider})"
  
  {
    email: user.email,
    username: user.email,
    fullName: user.name,
    verified: true,
    active: user.active,
    imageUrl: user.image_url,
    registrations: [
      {
        id: SecureRandom.uuid,
        applicationId: "84e302de-3839-444d-a5ee-950374f6b097",
        verified: true,
        roles: ["user"]
      }
    ],
    data: {
      source_system: "omniauth",
      original_user_id: user.id,
      oauth_provider: user.provider,
      oauth_uid: user.uid,
      locked_at: nil,
      confirmation_token: nil,
      last_sign_in_ip: nil,
      current_sign_in_ip: nil
    }
  }
end

# Write to file with proper FusionAuth format
export_data = { users: users_data }
filename = "users_export_#{Time.current.strftime('%Y%m%d_%H%M%S')}.json"
File.write(filename, JSON.pretty_generate(export_data))

puts ""
puts "Export completed successfully!"
puts "File saved as: #{filename}"
puts "Total users exported: #{users_data.count}"
puts "Providers: #{users_data.group_by { |u| u[:data][:oauth_provider] }.transform_values(&:count)}" 