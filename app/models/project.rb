class Project < ApplicationRecord
  belongs_to :user
  belongs_to :building, optional: true
  belongs_to :ground_type, optional: true

  has_many :working_well_systems
  has_many :energetic_studies
  has_many :studied_pipes
  has_many :working_pipes

  validates :name, presence: true, uniqueness: true
end
