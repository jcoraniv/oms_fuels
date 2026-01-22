class Department < ApplicationRecord
  belongs_to :gestion
  belongs_to :parent, class_name: 'Department', optional: true
  has_many :children, class_name: 'Department', foreign_key: 'parent_id', dependent: :destroy
  has_many :positions, dependent: :destroy

  validates :name, presence: true
  validates :level, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :gestion_id, presence: true

  scope :roots, -> { where(parent_id: nil) }
  scope :for_gestion, ->(gestion_id) { where(gestion_id: gestion_id) }
end
