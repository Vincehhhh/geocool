class WorkingWellSystem < ApplicationRecord
  belongs_to :project
  belongs_to :working_pipe

  validates :proposed_length_lo
  validates :proposed_number_of_pipes
  validates :occupied_area
  validates :proposed_total_length
  validates :nominal_speed
end
