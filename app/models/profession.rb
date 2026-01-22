class Profession < ApplicationRecord
  has_many :personals

  validates :name, presence: true, uniqueness: true
end
