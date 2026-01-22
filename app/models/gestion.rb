class Gestion < ApplicationRecord
  has_many :user_gestions, dependent: :destroy
  has_many :users, through: :user_gestions, source: :user
  has_many :org_structures, dependent: :destroy # New association
  has_many :org_positions, through: :org_structures # New association

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true

  scope :active, -> { where(active: true) }

  after_create :assign_to_all_users

  private

  def assign_to_all_users
    # Prepare data for a bulk insert
    user_gestions_data = User.pluck(:id).map do |user_id|
      { user_id: user_id, gestion_id: self.id, created_at: Time.current, updated_at: Time.current }
    end

    # Insert all records in a single query, ignoring duplicates if any
    UserGestion.insert_all(user_gestions_data, unique_by: [:user_id, :gestion_id]) if user_gestions_data.any?
  end
end
