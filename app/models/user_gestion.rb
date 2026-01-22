class UserGestion < ApplicationRecord
  belongs_to :user
  belongs_to :gestion

  validates :user_id, presence: true
  validates :gestion_id, presence: true
  validates :user_id, uniqueness: { scope: :gestion_id }
end
