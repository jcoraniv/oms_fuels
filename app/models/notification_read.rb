class NotificationRead < ApplicationRecord
  belongs_to :user
  belongs_to :gestion

  validates :notification_type, presence: true, uniqueness: { scope: [:user_id, :gestion_id] }
end
