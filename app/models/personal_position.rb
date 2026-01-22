class PersonalPosition < ApplicationRecord
  belongs_to :personal
  belongs_to :position
  belongs_to :gestion

  validates :personal_id, presence: true
  validates :position_id, presence: true
  validates :gestion_id, presence: true

  scope :current, -> { where(end_date: nil) }
  scope :for_gestion, ->(gestion_id) { where(gestion_id: gestion_id) }
end
