class Position < ApplicationRecord
  include SoftDeletable
  
  has_many :org_positions, dependent: :destroy
  has_many :org_structures, through: :org_positions
  has_many :gestions, through: :org_structures

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true
end
