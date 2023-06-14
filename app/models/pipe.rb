class Pipe < ApplicationRecord
  belongs_to :manufacturer

  has_many :studied_pipes
  has_many :working_pipes

  validates :material, presence: true, inclusion: { in: %w(FONTE GRES BETON PEHD POLYPROPYLENE POLY-PROP. AUTRE) }
  has_one_attached :photo

end
