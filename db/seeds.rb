# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
puts "Cleaning database..."
Pipe.destroy_all
User.destroy_all
Manufacturer.destroy_all

puts "Creating Manufacturer..."
elixair = Manufacturer.create!(
  social_name: "PAM-Elixair"
  address: ""
  admin_name: ""
)
file = File.open(Rails.root.join("db/seeds/users_img/Clara_light.jpg"))
clara.photo.attach(io: file, filename: "Clara_light.jpg", content_type: "image/jpeg")


puts "Creating users..."
#  status: %w(Newbie Intermediate Confirmed Professional).sample,

file = File.open(Rails.root.join("db/seeds/users_img/Clara_light.jpg"))
clara.photo.attach(io: file, filename: "Clara_light.jpg", content_type: "image/jpeg")

vince = User.create!(
  username: "vincent",
  email: "vhelpin@protonmail.com",
  password: "123456",
  experience: "Intermediate",
  biographie: "Ayant survécu à l'effondrement de la société, j'ai décidé de mettre mes connaissances en armes et en tactiques de survie au service des autres. En tant que survivaliste expérimenté, j'ai construit un marché d'armes florissant dans ce monde chaotique. Ma passion pour l'apprentissage et mon engagement envers la sécurité des survivants m'ont valu le respect et la confiance de nombreux groupes à travers la région."
)
file = File.open(Rails.root.join("db/seeds/users_img/vince_light.jpg"))
vince.photo.attach(io: file, filename: "vince_light.jpg", content_type: "image/jpeg")

puts "Creating weapons..."
