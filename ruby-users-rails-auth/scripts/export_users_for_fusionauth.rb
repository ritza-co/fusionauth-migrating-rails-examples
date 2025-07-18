#!/usr/bin/env ruby

# Simple User Export Script for Rails Authentication
# Exports users as plain JSON

require 'json'

puts "Starting user export for Rails Authentication users..."
puts "Found #{User.count} users to export"

users_data = User.all.map do |user|
  puts "Exporting user: #{user.email}"
  
  {
    id: user.id,
    email: user.email,
    name: user.name,
    password_digest: user.password_digest,
    confirmed_at: user.confirmed_at,
    reset_password_token: user.reset_password_token,
    reset_password_sent_at: user.reset_password_sent_at,
    remember_created_at: user.remember_created_at,
    sign_in_count: user.sign_in_count,
    current_sign_in_at: user.current_sign_in_at,
    last_sign_in_at: user.last_sign_in_at,
    current_sign_in_ip: user.current_sign_in_ip,
    last_sign_in_ip: user.last_sign_in_ip,
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
puts "Confirmed users: #{users_data.count { |u| u[:confirmed_at] }}" 