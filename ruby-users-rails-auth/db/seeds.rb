# Create seed data for testing Rails authentication
puts "Creating seed data for Rails authentication..."

# Create admin user
admin = User.find_or_create_by(email: "admin@example.com") do |user|
  user.name = "Admin User"
  user.password = "password123"
  user.password_confirmation = "password123"
  user.confirmed_at = 1.week.ago
  user.sign_in_count = 15
  user.current_sign_in_at = 1.day.ago
  user.last_sign_in_at = 3.days.ago
  user.current_sign_in_ip = "192.168.1.100"
  user.last_sign_in_ip = "192.168.1.99"
end

# Create regular user
regular_user = User.find_or_create_by(email: "user@example.com") do |user|
  user.name = "Regular User"
  user.password = "password123"
  user.password_confirmation = "password123"
  user.confirmed_at = 3.days.ago
  user.sign_in_count = 8
  user.current_sign_in_at = 2.hours.ago
  user.last_sign_in_at = 1.day.ago
  user.current_sign_in_ip = "192.168.1.101"
  user.last_sign_in_ip = "192.168.1.100"
end

# Create test user
test_user = User.find_or_create_by(email: "test@example.com") do |user|
  user.name = "Test User"
  user.password = "password123"
  user.password_confirmation = "password123"
  user.confirmed_at = 1.day.ago
  user.sign_in_count = 3
  user.current_sign_in_at = 4.hours.ago
  user.last_sign_in_at = 2.days.ago
  user.current_sign_in_ip = "192.168.1.102"
  user.last_sign_in_ip = "192.168.1.101"
end

# Create unconfirmed user
unconfirmed_user = User.find_or_create_by(email: "unconfirmed@example.com") do |user|
  user.name = "Unconfirmed User"
  user.password = "password123"
  user.password_confirmation = "password123"
  user.confirmed_at = nil
  user.sign_in_count = 0
end

puts "Created #{User.count} users:"
User.all.each do |user|
  status = user.confirmed? ? "confirmed" : "unconfirmed"
  puts "  - #{user.name} (#{user.email}) - #{status}, #{user.sign_in_count} sign-ins"
end

puts "Seed data creation complete!"
puts ""
puts "You can now:"
puts "1. Start the server: rails server"
puts "2. Login with any of these accounts using password 'password123'"
puts "3. Export users to FusionAuth: rails runner scripts/export_users_for_fusionauth.rb"
