class Gestion < ApplicationRecord
  include SoftDeletable
  
  has_many :user_gestions, dependent: :destroy
  has_many :users, through: :user_gestions, source: :user
  has_many :org_structures, dependent: :destroy
  has_many :org_positions, through: :org_structures

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true

  scope :active_gestions, -> { where(active: true) }

  after_create :assign_to_all_users

  def self.ransackable_attributes(auth_object = nil)
    ["code", "name", "active", "status", "created_at", "updated_at"]
  end

  def self.default
    Gestion.where(active: true)&.last
  end

  private

  def assign_to_all_users
    user_gestions_data = User.pluck(:id).map do |user_id|
      { user_id: user_id, gestion_id: self.id, created_at: Time.current, updated_at: Time.current }
    end

    UserGestion.insert_all(user_gestions_data, unique_by: [:user_id, :gestion_id]) if user_gestions_data.any?
  end
end
