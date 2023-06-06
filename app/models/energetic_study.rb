class EnergeticStudy < ApplicationRecord
  belongs_to :project

  has_many :energetic_results
end
