class Position < ApplicationRecord
  belongs_to :department
  belongs_to :gestion
  has_many :personal_positions, dependent: :destroy
  has_many :personals, through: :personal_positions

  validates :name, presence: true
  validates :department_id, presence: true
  validates :gestion_id, presence: true

  scope :for_gestion, ->(gestion_id) { where(gestion_id: gestion_id) }
end
