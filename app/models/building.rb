class Building < ApplicationRecord
  has_many :projects

  validates :area, presence: true, numericality: { greater_than: 0, too_long: "%{count} is the maximum allowed" }
  # validates :available_area , presence: true, numericality: { greater_than: 0 }
  # validates :postal_code, presence: true
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

  validates :nominal_flow_rate, presence: true, numericality: { greater_than: 0, too_long: "%{count} characters is the maximum allowed" }

end
