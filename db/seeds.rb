puts "🌱 Starting seeds..."

# Professions
puts "Creating professions..."
profession_ing = Profession.find_or_create_by!(name: 'Ingeniero de Sistemas')
profession_admin = Profession.find_or_create_by!(name: 'Administrador')
profession_tec = Profession.find_or_create_by!(name: 'Técnico')

# Personal
puts "Creating personal..."
personal_admin = Personal.find_or_create_by!(ci: '12345678') do |p|
  p.first_name = 'Samuel'
  p.last_name = 'Gareca'
  p.email = 'samuel.gareca@oms.com'
  p.phone = '70123456'
  p.profession = profession_ing
end

personal_operation = Personal.find_or_create_by!(ci: '87654321') do |p|
  p.first_name = 'María'
  p.last_name = 'López'
  p.email = 'maria.lopez@oms.com'
  p.phone = '70234567'
  p.profession = profession_admin
end

personal_employee = Personal.find_or_create_by!(ci: '11223344') do |p|
  p.first_name = 'Carlos'
  p.last_name = 'Pérez'
  p.email = 'carlos.perez@oms.com'
  p.phone = '70345678'
  p.profession = profession_tec
end

# Roles
puts "Creating roles..."
admin_role = Role.find_or_create_by!(name: 'Admin')
operation_role = Role.find_or_create_by!(name: 'Operation')
employee_role = Role.find_or_create_by!(name: 'Employee')

# Users
puts "Creating users..."
admin_user = User.find_or_create_by!(username: 'sgareca') do |u|
  u.password = 'sgareca'
  u.password_confirmation = 'sgareca'
  u.role = admin_role
  u.personal = personal_admin
  u.status = 0
end

operation_user = User.find_or_create_by!(username: 'mlopez') do |u|
  u.password = 'mlopez'
  u.password_confirmation = 'mlopez'
  u.role = operation_role
  u.personal = personal_operation
  u.status = 0
end

employee_user = User.find_or_create_by!(username: 'cperez') do |u|
  u.password = 'cperez'
  u.password_confirmation = 'cperez'
  u.role = employee_role
  u.personal = personal_employee
  u.status = 0
end

# Gestion 2026
puts "Creating gestion 2026..."
gestion_2026 = Gestion.find_or_create_by!(code: '2026') do |g|
  g.name = 'Gestion 2026'
  g.active = true
end

# UserGestions
puts "Assigning gestion to users..."
UserGestion.find_or_create_by!(user: admin_user, gestion: gestion_2026) do |ug|
  ug.current = true
end

UserGestion.find_or_create_by!(user: operation_user, gestion: gestion_2026) do |ug|
  ug.current = true
end

UserGestion.find_or_create_by!(user: employee_user, gestion: gestion_2026) do |ug|
  ug.current = true
end

# Fuels
puts "Creating fuels..."
Fuel.find_or_create_by!(description: 'Gasolina Especial') do |f|
  f.unit_of_measure = 'liter'
  f.reference_price = 3.74
  f.status = 0
end

Fuel.find_or_create_by!(description: 'Gasolina Premium') do |f|
  f.unit_of_measure = 'liter'
  f.reference_price = 5.20
  f.status = 0
end

Fuel.find_or_create_by!(description: 'Diésel') do |f|
  f.unit_of_measure = 'liter'
  f.reference_price = 3.72
  f.status = 0
end

Fuel.find_or_create_by!(description: 'GNV (Gas Natural Vehicular)') do |f|
  f.unit_of_measure = 'cubic_meter'
  f.reference_price = 1.50
  f.status = 0
end

Fuel.find_or_create_by!(description: 'GLP (Gas Licuado de Petróleo)') do |f|
  f.unit_of_measure = 'liter'
  f.reference_price = 2.10
  f.status = 0
end

# Vehicle Types
puts "Creating vehicle types..."
camion_cisterna = VehicleType.find_or_create_by!(name: 'Camión Cisterna') do |vt|
  vt.description = 'Vehículo para transporte de agua potable'
end

camion_vactor = VehicleType.find_or_create_by!(name: 'Camión Vactor') do |vt|
  vt.description = 'Vehículo para limpieza de alcantarillado y desatoros'
end

camioneta = VehicleType.find_or_create_by!(name: 'Camioneta') do |vt|
  vt.description = 'Vehículo liviano para supervisión y transporte de personal'
end

retroexcavadora = VehicleType.find_or_create_by!(name: 'Retroexcavadora') do |vt|
  vt.description = 'Maquinaria para excavación y reparación de tuberías'
end

camion_volqueta = VehicleType.find_or_create_by!(name: 'Camión Volqueta') do |vt|
  vt.description = 'Vehículo para transporte de materiales y escombros'
end

motocicleta = VehicleType.find_or_create_by!(name: 'Motocicleta') do |vt|
  vt.description = 'Vehículo para inspección rápida y lectura de medidores'
end

# Vehicles
puts "Creating vehicles..."
Vehicle.find_or_create_by!(plate: '1234-ABC') do |v|
  v.vehicle_type = camion_cisterna
  v.description = 'Camión Cisterna Hino 15000L'
  v.details = 'Capacidad 15000 litros, año 2020'
  v.status = 0
end

Vehicle.find_or_create_by!(plate: '5678-DEF') do |v|
  v.vehicle_type = camion_cisterna
  v.description = 'Camión Cisterna Mercedes Benz 12000L'
  v.details = 'Capacidad 12000 litros, año 2019'
  v.status = 0
end

Vehicle.find_or_create_by!(plate: '9012-GHI') do |v|
  v.vehicle_type = camion_vactor
  v.description = 'Camión Vactor Isuzu'
  v.details = 'Sistema de succión y presión, año 2021'
  v.status = 0
end

Vehicle.find_or_create_by!(plate: '3456-JKL') do |v|
  v.vehicle_type = camioneta
  v.description = 'Toyota Hilux 4x4'
  v.details = 'Doble cabina, año 2022'
  v.status = 0
end

Vehicle.find_or_create_by!(plate: '7890-MNO') do |v|
  v.vehicle_type = camioneta
  v.description = 'Nissan Frontier'
  v.details = 'Doble cabina, año 2021'
  v.status = 0
end

Vehicle.find_or_create_by!(plate: '2345-PQR') do |v|
  v.vehicle_type = retroexcavadora
  v.description = 'Caterpillar 416F'
  v.details = 'Retroexcavadora cargadora, año 2018'
  v.status = 0
end

Vehicle.find_or_create_by!(plate: '6789-STU') do |v|
  v.vehicle_type = camion_volqueta
  v.description = 'Volvo FMX 8x4'
  v.details = 'Capacidad 20m³, año 2020'
  v.status = 0
end

Vehicle.find_or_create_by!(plate: '0123-VWX') do |v|
  v.vehicle_type = motocicleta
  v.description = 'Honda XR 190'
  v.details = 'Motocicleta enduro, año 2023'
  v.status = 0
end

Vehicle.find_or_create_by!(plate: '4567-YZA') do |v|
  v.vehicle_type = motocicleta
  v.description = 'Yamaha XTZ 125'
  v.details = 'Motocicleta trail, año 2022'
  v.status = 0
end

puts "✅ Seeds completed successfully!"
puts "\n👥 Users created:"
puts "  Admin    - Username: sgareca | Password: sgareca"
puts "  Operation - Username: mlopez  | Password: mlopez"
puts "  Employee  - Username: cperez  | Password: cperez"
puts "\n📊 Data summary:"
puts "  🚗 #{Vehicle.count} vehicles"
puts "  🏷️  #{VehicleType.count} vehicle types"
puts "  ⛽ #{Fuel.count} fuels"
