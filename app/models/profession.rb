class Profession < ApplicationRecord
  include SoftDeletable
  
  has_many :personals

  validates :name, presence: true, uniqueness: true
end
