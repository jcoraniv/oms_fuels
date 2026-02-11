class Department < ApplicationRecord
  include SoftDeletable
  
  has_many :org_structures, dependent: :destroy
  has_many :gestions, through: :org_structures
  has_many :org_positions, through: :org_structures

  validates :name, presence: true
end
