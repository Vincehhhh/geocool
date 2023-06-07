class Manufacturer < ApplicationRecord
  belongs_to :user
  has_many :pipes

  validates :social_name, presence: true
  validates :address, presence: true
end
