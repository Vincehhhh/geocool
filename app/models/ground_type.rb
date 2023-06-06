class GroundType < ApplicationRecord
  has_many :projects

  validates :name, presence: true
  validates :slug, presence: true
  validates :thermal_conductivity, presence: true
  validates :density, presence: true
  validates :heat_capacity, presence: true
end
