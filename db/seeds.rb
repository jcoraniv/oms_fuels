puts "🌱 Starting seeds..."

# Profession
puts "Creating profession..."
profession = Profession.find_or_create_by!(name: 'Ingeniero de Sistemas')

# Personal
puts "Creating personal..."
personal = Personal.find_or_create_by!(ci: '12345678') do |p|
  p.first_name = 'Samuel'
  p.last_name = 'Gareca'
  p.email = 'samuel.gareca@oms.com'
  p.phone = '70123456'
  p.profession = profession
end

# Role Admin
puts "Creating admin role..."
admin_role = Role.find_or_create_by!(name: 'Admin')
Role.find_or_create_by!(name: 'Operation')
Role.find_or_create_by!(name: 'Employee')

# Admin User
puts "Creating admin user..."
admin_user = User.find_or_create_by!(username: 'sgareca') do |u|
  u.password = 'sgareca'
  u.password_confirmation = 'sgareca'
  u.role = admin_role
  u.personal = personal
  u.status = 0
end

# Gestion 2026
puts "Creating gestion 2026..."
gestion_2026 = Gestion.find_or_create_by!(code: '2026') do |g|
  g.name = 'Gestion 2026'
  g.active = true
end

# UserGestion
puts "Assigning gestion to user..."
UserGestion.find_or_create_by!(user: admin_user, gestion: gestion_2026) do |ug|
  ug.current = true
end

puts "✅ Seeds completed successfully!"
puts "👤 Username: sgareca"
puts "🔑 Password: oms.@dm1n"
