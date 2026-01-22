class Department < ApplicationRecord
  has_many :org_structures, dependent: :destroy # New association
  has_many :gestions, through: :org_structures # New association
  has_many :org_positions, through: :org_structures # New association

  validates :name, presence: true
end
