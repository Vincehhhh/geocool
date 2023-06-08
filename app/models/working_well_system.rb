class WorkingWellSystem < ApplicationRecord
  belongs_to :project, optional: true
  belongs_to :pipe, optional: true

  validates :proposed_length_lo, presence: true
  validates :proposed_number_of_pipes, presence: true
  validates :occupied_area, presence: true
  validates :proposed_total_length, presence: true
  validates :nominal_speed, presence: true
end
