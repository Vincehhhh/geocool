class Pipe < ApplicationRecord
  belongs_to :manufacturer

  has_many :studied_pipes
  has_many :working_pipes

  
end
