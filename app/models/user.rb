class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :projects
  has_many :manufacturers

  validates :occupation, presence: true, inclusion:  { in: %w(Architecte Ingénieur Etudiant Artisan Particulier Autre),
    message: "%{value} is not a valid category" }
end
