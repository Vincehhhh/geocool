class WorkingWellSystem < ApplicationRecord
  belongs_to :project
  belongs_to :working_pipe

  validates :proposed_length_lo, presence: true
  validates :proposed_number_of_pipes, presence: true
  validates :occupied_area, presence: true
  validates :proposed_total_length, presence: true
  validates :nominal_speed, presence: true
end
