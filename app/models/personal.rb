class Personal < ApplicationRecord
  include SoftDeletable
  
  belongs_to :profession, optional: true
  has_one :user, dependent: :destroy
  has_many :assignments, dependent: :destroy
  has_many :org_positions, through: :assignments

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :ci, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    ["first_name", "last_name", "email", "phone", "ci", "profession_id", "status", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["profession", "user", "assignments", "org_positions"]
  end

  def full_name
    "#{first_name} #{last_name}".strip
  end
end
