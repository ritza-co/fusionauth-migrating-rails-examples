#!/usr/bin/env ruby

# Simple User Export Script for OmniAuth Users
# Exports users as plain JSON

require_relative 'config/environment'
require 'json'

puts "Starting user export for OmniAuth users..."
puts "Found #{User.count} users to export"

users_data = User.all.map do |user|
  puts "Exporting user: #{user.email} (#{user.provider})"
  
  {
    id: user.id,
    email: user.email,
    name: user.name,
    provider: user.provider,
    uid: user.uid,
    image_url: user.image_url,
    active: user.active,
    created_at: user.created_at,
    updated_at: user.updated_at
  }
end

# Write to file
filename = "users_export_#{Time.current.strftime('%Y%m%d_%H%M%S')}.json"
File.write(filename, JSON.pretty_generate(users_data))

puts ""
puts "Export completed successfully!"
puts "File saved as: #{filename}"
puts "Total users exported: #{users_data.count}"
puts "Providers: #{users_data.group_by { |u| u[:provider] }.transform_values(&:count)}" 