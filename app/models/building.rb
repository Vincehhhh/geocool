class Building < ApplicationRecord
  has_many :projects

  validates :area, presence: true
  validates :postal_code, presence: true
  validates :city_name, presence: true
  validates :building_type, presence: true, inclusion: { in: [
    "Neuf",
    "Rénovation",
    "Mixte : Neuf / Rénovation"
    ]}

  validates :category, presence: true, inclusion: { in: [
    "Maison individuelle",
    "Logement Collectif",
    "Bureaux",
    "Chai Vini-viticole",
    "Groupe Scolaire",
    "Enseignement Secondaire / Université"
    ]}

  validates :nominal_flow_rate, presence: true


end
