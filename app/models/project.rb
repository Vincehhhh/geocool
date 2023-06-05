class Project < ApplicationRecord
  belongs_to :user
  belongs_to :building
  belongs_to :ground_type
  belongs_to :pipe
end
