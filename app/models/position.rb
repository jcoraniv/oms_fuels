class Position < ApplicationRecord
  has_many :org_positions, dependent: :destroy # New association
  has_many :org_structures, through: :org_positions # New association
  has_many :gestions, through: :org_structures # New association

  validates :name, presence: true
end
