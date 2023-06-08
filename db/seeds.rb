# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
puts "Cleaning database..."
Pipe.destroy_all
Manufacturer.destroy_all
Building.destroy_all
Project.destroy_all
User.destroy_all

puts "Creating users"
vince = User.create!(
  email: "vhelpin@protonmail.com",
  password: "123456",
  occupation: "Ingénieur",
  premium_status: true,
  company_name:"Turtwell"
)

bastien = User.create!(
  email: "bastien@gmail.com",
  password: "123456",
  occupation: "Architecte",
  premium_status: false,
  company_name:"my_archi"
)

clement = User.create!(
  email: "clement@gmail.com",
  password: "123456",
  occupation: "Architecte",
  premium_status: true,
  company_name:"my_archi"
)

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
  diameter_ext_mm: 166.4,
  manufacturer: elixair
)
elixair150.diameter_int = elixair150.diameter_ext_mm - ( 2 * elixair150.thickness_mm)
elixair150.save

elixair300 = Pipe.create!(
  material: "FONTE",
  nominal_diameter_dn: "DN-300",
  name: "PAM Elixair 300",
  thermal_conductivity: 36,
  thickness_mm: 4.8,
  diameter_ext_mm: 326,
  manufacturer: elixair
)
elixair300.diameter_int = elixair300.diameter_ext_mm - ( 2 * elixair300.thickness_mm)
elixair300.save

elixair500 = Pipe.create!(
  material: "FONTE",
  nominal_diameter_dn: "DN-500",
  name: "PAM Elixair 500",
  thermal_conductivity: 36,
  thickness_mm: 7.0,
  diameter_ext_mm: 532,
  manufacturer: elixair
)
elixair500.diameter_int = elixair500.diameter_ext_mm - ( 2 * elixair500.thickness_mm)
elixair500.save

elixair100 = Pipe.create!(
  material: "FONTE",
  nominal_diameter_dn: "DN-100",
  name: "PAM Elixair 100",
  thermal_conductivity: 36,
  thickness_mm: 3.0,
  diameter_ext_mm: 103,
  manufacturer: elixair
)
elixair100.diameter_int = elixair100.diameter_ext_mm - ( 2 * elixair100.thickness_mm)
elixair100.save

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
helios300.save

puts "Creating grounds..."

argile_humide = GroundType.create!(
  name:'Argile Humide_RT2012',
  slug:'argile_humide_rt2012',
  lambda_ground: 1.45,
  density:  1800,
  heat_capacity: 1340
)

sable_humide = GroundType.create!(
  slug:'sable_humide_rt2012',
  name:'Sable Humide_RT2012',
  lambda_ground: 1.88,
  density: 1500,
  heat_capacity: 1200
)

sable_sec = GroundType.create!(
  slug:'sable_sec_rt2012',
  name:'Sable Sec RT2012',
  lambda_ground: 0.70,
  density: 1500,
  heat_capacity: 920
)

sable_sec = GroundType.create!(
  slug:'tourbe',
  name:'Tourbe',
  lambda_ground: 0.20,
  density: 500,
  heat_capacity: 3200
)


puts "Seeds Finished!"
