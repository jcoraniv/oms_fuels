class Personal < ApplicationRecord
  include SoftDeletable
  
  belongs_to :profession, optional: true
  has_one :user, dependent: :destroy
  has_many :assignments, dependent: :destroy
  has_many :org_positions, through: :assignments

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :ci, presence: true, uniqueness: true

  def full_name
    "#{first_name} #{last_name}".strip
  end
end
