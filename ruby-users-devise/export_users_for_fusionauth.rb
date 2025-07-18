#!/usr/bin/env ruby

# Simple User Export Script for Devise Users
# Exports users as plain JSON

require_relative 'config/environment'
require 'json'

puts "Starting user export for Devise users..."
puts "Found #{User.count} users to export"

users_data = User.all.map do |user|
  puts "Exporting user: #{user.email}"
  
  {
    id: user.id,
    email: user.email,
    name: user.respond_to?(:name) && user.name.present? ? user.name : user.email.split('@').first,
    encrypted_password: user.encrypted_password,
    confirmed: user.respond_to?(:confirmed?) ? user.confirmed? : true,
    confirmed_at: user.respond_to?(:confirmed_at) ? user.confirmed_at : nil,
    created_at: user.created_at,
    updated_at: user.updated_at,
    last_sign_in_at: user.respond_to?(:last_sign_in_at) ? user.last_sign_in_at : nil,
    sign_in_count: user.respond_to?(:sign_in_count) ? user.sign_in_count : 0
  }
end

# Write to file
filename = "users_export_#{Time.current.strftime('%Y%m%d_%H%M%S')}.json"
File.write(filename, JSON.pretty_generate(users_data))

puts ""
puts "Export completed successfully!"
puts "File saved as: #{filename}"
puts "Total users exported: #{users_data.count}" 