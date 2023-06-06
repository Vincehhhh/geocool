class WorkingPipe < ApplicationRecord
  belongs_to :project
  belongs_to :pipe

  has_many :working_well_systems
end
