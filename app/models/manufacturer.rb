class Manufacturer < ApplicationRecord
  belongs_to :user
  has_many :pipes
end
