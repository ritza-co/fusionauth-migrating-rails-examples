# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The data can then be loaded with the bin/rails db:seed command (or created alongside the database
# with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Creating seed data for OmniAuth demo..."

# Create sample users for testing
users_data = [
  {
    email: "john.doe@example.com",
    name: "John Doe",
    provider: "google_oauth2",
    uid: "123456789",
    image_url: "https://via.placeholder.com/80/667eea/ffffff?text=JD",
    raw_info: {
      "provider" => "google_oauth2",
      "uid" => "123456789",
      "info" => {
        "name" => "John Doe",
        "email" => "john.doe@example.com",
        "given_name" => "John",
        "family_name" => "Doe",
        "image" => "https://via.placeholder.com/80/667eea/ffffff?text=JD",
        "verified_email" => true,
        "locale" => "en"
      },
      "credentials" => {
        "token" => "sample_token_123",
        "refresh_token" => "sample_refresh_token_123",
        "expires_at" => 1.hour.from_now.to_i
      }
    },
    active: true
  },
  {
    email: "jane.smith@example.com",
    name: "Jane Smith",
    provider: "google_oauth2",
    uid: "987654321",
    image_url: "https://via.placeholder.com/80/764ba2/ffffff?text=JS",
    raw_info: {
      "provider" => "google_oauth2",
      "uid" => "987654321",
      "info" => {
        "name" => "Jane Smith",
        "email" => "jane.smith@example.com",
        "given_name" => "Jane",
        "family_name" => "Smith",
        "image" => "https://via.placeholder.com/80/764ba2/ffffff?text=JS",
        "verified_email" => true,
        "locale" => "en"
      },
      "credentials" => {
        "token" => "sample_token_456",
        "refresh_token" => "sample_refresh_token_456",
        "expires_at" => 1.hour.from_now.to_i
      }
    },
    active: true
  },
  {
    email: "dev@example.com",
    name: "Developer User",
    provider: "developer",
    uid: "dev@example.com",
    image_url: "https://via.placeholder.com/80/28a745/ffffff?text=DEV",
    raw_info: {
      "provider" => "developer",
      "uid" => "dev@example.com",
      "info" => {
        "name" => "Developer User",
        "email" => "dev@example.com"
      }
    },
    active: true
  }
]

users_data.each do |user_data|
  user = User.find_or_initialize_by(provider: user_data[:provider], uid: user_data[:uid])
  
  if user.new_record?
    user.assign_attributes(user_data)
    user.save!
    puts "Created user: #{user.name} (#{user.email}) via #{user.provider_name}"
  else
    puts "User already exists: #{user.name} (#{user.email}) via #{user.provider_name}"
  end
end

puts "Seed data creation complete!"
puts "Total users: #{User.count}"
puts "Active users: #{User.active.count}"
puts "Google users: #{User.by_provider('google_oauth2').count}"
puts "Developer users: #{User.by_provider('developer').count}"
