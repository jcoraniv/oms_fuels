class Personal < ApplicationRecord
  belongs_to :profession, optional: true
  has_one :user, dependent: :destroy
  has_many :personal_positions, dependent: :destroy
  has_many :positions, through: :personal_positions
  has_many :gestions, -> { distinct }, through: :personal_positions

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :ci, presence: true, uniqueness: true

  def full_name
    "#{first_name} #{last_name}".strip
  end
end
