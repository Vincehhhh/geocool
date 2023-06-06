class EnergeticStudy < ApplicationRecord
  belongs_to :project

  has_many :energetic_results
  validates :start_heating_date, presence: true
  validates :end_heating_date, presence: true
  validates :studied_length, presence: true
  validates :number_of_branches, presence: true
  validates :underground_depth, presence: true
end
