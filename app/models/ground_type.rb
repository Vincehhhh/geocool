class GroundType < ApplicationRecord
  has_many :projects

  validates :name, presence: true
  validates :lambda_ground, presence: true
  validates :density, presence: true
  validates :heat_capacity, presence: true
  has_one_attached :photo

end
