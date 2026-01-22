# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# --- Professions ---
# puts "Seeding Professions..."
# professions = ["Senior Technician", "Worker", "Bachelor's Degree", "Master's Degree"]
# professions.each { |name| Profession.find_or_create_by!(name: name) }
# puts "Professions seeded."

# --- Gestions ---
puts "Seeding Gestions..."
gestions_data = [
  { code: "2023", name: "Gestion 2023" },
  { code: "2024", name: "Gestion 2024" },
  { code: "2025", name: "Gestion 2025" }
]
gestions_data.each do |attrs|
  Gestion.find_or_create_by!(code: attrs[:code]) do |gestion|
    gestion.name = attrs[:name]
  end
end
puts "Gestions seeded."

# --- Roles ---
puts "Seeding Roles..."
admin_role = Role.find_or_create_by!(name: 'Admin')
employee_role = Role.find_or_create_by!(name: 'Employee')
puts "Roles seeded."

# --- Admin User ---
puts "Seeding Admin User..."
admin_personal = Personal.find_or_create_by!(email: 'admin@example.com') do |p|
  p.first_name = 'Admin'
  p.last_name = 'User'
  p.ci = '0000000'
end

admin_user = User.find_or_create_by!(email: 'admin@example.com') do |u|
  u.password = 'password'
  u.password_confirmation = 'password'
  u.role = admin_role
  u.personal = admin_personal
  u.active = true
end
puts "Admin User seeded."

# --- UserGestions for Admin ---
puts "Seeding UserGestions for Admin..."
Gestion.all.each do |gestion|
  UserGestion.find_or_create_by!(user: admin_user, gestion: gestion)
end
puts "UserGestions for Admin seeded."
