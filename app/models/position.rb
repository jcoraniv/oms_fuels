class Position < ApplicationRecord
  has_many :org_positions, dependent: :destroy
  has_many :org_structures, through: :org_positions
  has_many :gestions, through: :org_structures

  enum :status, { active: 0, archived: 1, deleted: 2 }

  validates :name, presence: true
  validates :code, presence: true, uniqueness: true

  scope :not_deleted, -> { where.not(status: :deleted) }
end
