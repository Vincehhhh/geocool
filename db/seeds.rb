# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
puts "Cleaning database..."
Project.destroy_all
Pipe.destroy_all
Manufacturer.destroy_all
Building.destroy_all
GroundType.destroy_all
User.destroy_all


puts "Creating users"
vince = User.create!(
  email: "vhelpin@protonmail.com",
  password: "123456",
  occupation: "Ingénieur",
  premium_status: true,
  company_name: "Turtwell"
)
file = File.open(Rails.root.join("db/seeds_pics/users/vince_light.jpg"))
vince.photo.attach(io: file, filename: "vince_light.jpg", content_type: "image/jpeg")

bastien = User.create!(
  email: "bastien@gmail.com",
  password: "123456",
  occupation: "Architecte",
  premium_status: false,
  company_name: "my_archi"
)
file = File.open(Rails.root.join("db/seeds_pics/users/vince_light.jpg"))
bastien.photo.attach(io: file, filename: "vince_light.jpg", content_type: "image/jpeg")

clement = User.create!(
  email: "clement@gmail.com",
  password: "123456",
  occupation: "Architecte",
  premium_status: true,
  company_name: "my_archi"
)
file = File.open(Rails.root.join("db/seeds_pics/users/vince_light.jpg"))
clement.photo.attach(io: file, filename: "vince_light.jpg", content_type: "image/jpeg")

# file = File.open(Rails.root.join("db/seeds/users_img/vince_light.jpg"))
# vince.photo.attach(io: file, filename: "vince_light.jpg", content_type: "image/jpeg")
puts "Creating manufacturers"
elixair = Manufacturer.create!(
  social_name: "Saint-Gobain PAM-Building",
  address: "21 avenue Camille Cavallier - 54705 PONT A MOUSSON",
  user: vince
)
# file = File.open(Rails.root.join("db/seeds/users_img/Clara_light.jpg"))
# man1.photo.attach(io: file, filename: "Clara_light.jpg", content_type: "image/jpeg")

helios = Manufacturer.create!(
  social_name: "Helios",
  address: "21 avenue Camille Cavallier - 54705 PONT A MOUSSON",
  user: bastien
)
# file = File.open(Rails.root.join("db/seeds/users_img/Clara_light.jpg"))
# man2.photo.attach(io: file, filename: "Clara_light.jpg", content_type: "image/jpeg")
le_pc = Manufacturer.create!(
  social_name: "Le Puits Canadien",
  address: "Zone artisanale des Tanneries - 38780 Pont-Evêque",
  user: clement
)

rehau  = Manufacturer.create!(
  social_name: "REHAU",
  address: "Zone artisanale des Tanneries - 38780 Pont-Evêque",
  user: clement
)

# file = File.open(Rails.root.join("db/seeds/users_img/Clara_light.jpg"))
# man3.photo.attach(io: file, filename: "Clara_light.jpg", content_type: "image/jpeg")
puts "Creating users..."
#  status: %w(Newbie Intermediate Confirmed Professional).sample,
puts "Creating pipes..."

elixair150 = Pipe.create!(
  material: "FONTE",
  nominal_diameter_dn: "DN-150",
  name: "PAM Elixair 150",
  thermal_conductivity: 36,
  thickness_mm: 3.4,
  diameter_ext_mm: 169.8,
  manufacturer: elixair
)
elixair150.diameter_int = elixair150.diameter_ext_mm - ( 2 * elixair150.thickness_mm)
file = File.open(Rails.root.join("db/seeds_pics/pipes/fonte1.jpg"))
elixair150.photo.attach(io: file, filename: "fonte1.jpg", content_type: "image/jpeg")
elixair150.save


elixair300 = Pipe.create!(
  material: "FONTE",
  nominal_diameter_dn: "DN-300",
  name: "PAM Elixair 300",
  thermal_conductivity: 36,
  thickness_mm: 4.8,
  diameter_ext_mm: 326.6,
  manufacturer: elixair
)
elixair300.diameter_int = elixair300.diameter_ext_mm - ( 2 * elixair300.thickness_mm)
file = File.open(Rails.root.join("db/seeds_pics/pipes/fonte1.jpg"))
elixair300.photo.attach(io: file, filename: "fonte1.jpg", content_type: "image/jpeg")

elixair300.save

elixair500 = Pipe.create!(
  material: "FONTE",
  nominal_diameter_dn: "DN-500",
  name: "PAM Elixair 500",
  thermal_conductivity: 36.0,
  thickness_mm: 7.0,
  diameter_ext_mm: 532,
  manufacturer: elixair
)
elixair500.diameter_int = elixair500.diameter_ext_mm - ( 2 * elixair500.thickness_mm)
file = File.open(Rails.root.join("db/seeds_pics/pipes/fonte1.jpg"))
elixair500.photo.attach(io: file, filename: "fonte1.jpg", content_type: "image/jpeg")

elixair500.save

# elixair100 = Pipe.create!(
#   material: "FONTE",
#   nominal_diameter_dn: "DN-100",
#   name: "PAM Elixair 100",
#   thermal_conductivity: 36,
#   thickness_mm: 3.0,
#   diameter_ext_mm: 103,
#   manufacturer: elixair
# )
# elixair100.diameter_int = elixair100.diameter_ext_mm - ( 2 * elixair100.thickness_mm)
# file = File.open(Rails.root.join("db/seeds_pics/pipes/fonte1.jpg"))
# elixair100.photo.attach(io: file, filename: "fonte1.jpg", content_type: "image/jpeg")
# elixair100.save

helios150 = Pipe.create!(
  material: "PEHD",
  nominal_diameter_dn: "DN-150",
  name: "Helios 200",
  thermal_conductivity: 0.3,
  thickness_mm: 5.0,
  diameter_ext_mm: 196,
  manufacturer: helios
)
helios150.diameter_int = helios150.diameter_ext_mm - ( 2 * helios150.thickness_mm)
file = File.open(Rails.root.join("db/seeds_pics/pipes/Polyethylene.jpg"))
helios150.photo.attach(io: file, filename: "Polyethylene.jpg", content_type: "image/jpeg")
helios150.save

helios200 = Pipe.create!(
  material: "PEHD",
  nominal_diameter_dn: "DN-200",
  name: "Helios 200",
  thermal_conductivity: 0.3,
  thickness_mm: 7.0,
  diameter_ext_mm: 214,
  manufacturer: helios
)
helios200.diameter_int = helios200.diameter_ext_mm - ( 2 * helios200.thickness_mm)
file = File.open(Rails.root.join("db/seeds_pics/pipes/Polyethylene.jpg"))
helios200.photo.attach(io: file, filename: "Polyethylene.jpg", content_type: "image/jpeg")
helios200.save

helios300 = Pipe.create!(
  material: "PEHD",
  nominal_diameter_dn: "DN-200",
  name: "Helios 300",
  thermal_conductivity: 0.3,
  thickness_mm: 10.0,
  diameter_ext_mm: 320,
  manufacturer: helios
)
helios300.diameter_int = helios300.diameter_ext_mm - ( 2 * helios300.thickness_mm)
file = File.open(Rails.root.join("db/seeds_pics/pipes/Polyethylene.jpg"))
helios300.photo.attach(io: file, filename: "Polyethylene.jpg", content_type: "image/jpeg")
helios300.save

puts "Creating grounds..."

argile_humide = GroundType.create!(
  name:'Argile humide RT2012',
  slug:'argile_humide_rt2012',
  lambda_ground: 1.45,
  density:  1800,
  heat_capacity: 1340
)
file = File.open(Rails.root.join("db/seeds_pics/ground_types/argileHumide.png"))
argile_humide.photo.attach(io: file, filename: "argileHumide.jpg", content_type: "image/jpeg")


sable_humide = GroundType.create!(
  slug:'sable_humide_rt2012',
  name:'Sable humide RT2012',
  lambda_ground: 1.88,
  density: 1500,
  heat_capacity: 1200
)
file = File.open(Rails.root.join("db/seeds_pics/ground_types/sableHumide.png"))
sable_humide.photo.attach(io: file, filename: "sableHumide.jpg", content_type: "image/jpeg")


sable_sec = GroundType.create!(
  slug:'sable_sec_rt2012',
  name:'Sable sec RT2012',
  lambda_ground: 0.70,
  density: 1500,
  heat_capacity: 920
)
file = File.open(Rails.root.join("db/seeds_pics/ground_types/sableSec.png"))
sable_sec.photo.attach(io: file, filename: "sableSec.jpg", content_type: "image/jpeg")


limon = GroundType.create!(
  slug:'limons',
  name:'Limons',
  lambda_ground: 0.20,
  density: 500,
  heat_capacity: 3200
)
file = File.open(Rails.root.join("db/seeds_pics/ground_types/Limons.png"))
limon.photo.attach(io: file, filename: "Limons.jpg", content_type: "image/jpeg")


calcaire = GroundType.create!(
  slug:'calcaire',
  name:'Calcaire',
  lambda_ground: 0.40,
  density: 1800,
  heat_capacity: 778
)
file = File.open(Rails.root.join("db/seeds_pics/ground_types/calcaire.png"))
calcaire.photo.attach(io: file, filename: "calcaire.jpg", content_type: "image/jpeg")


argile_sec = GroundType.create!(
  slug:'argile_sec',
  name:'Argile sec',
  lambda_ground: 0.40,
  density: 1800,
  heat_capacity: 833,
)
file = File.open(Rails.root.join("db/seeds_pics/ground_types/argileSec.png"))
argile_sec.photo.attach(io: file, filename: "argileSec.jpg", content_type: "image/jpeg")

puts "Seeds Finished!"
