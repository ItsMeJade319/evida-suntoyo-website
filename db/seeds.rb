# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Provisions the first admin from ENV vars, so credentials never land in source control.
# Usage: ADMIN_EMAIL=you@example.com ADMIN_PASSWORD=changeme bin/rails db:seed
if (email = ENV["ADMIN_EMAIL"]) && (password = ENV["ADMIN_PASSWORD"])
  admin = Admin.find_or_initialize_by(email: email)
  admin.password = password
  admin.save!
  puts "Admin account ready: #{email}"
else
  puts "Skipping admin seed — set ADMIN_EMAIL and ADMIN_PASSWORD to create/update one."
end
