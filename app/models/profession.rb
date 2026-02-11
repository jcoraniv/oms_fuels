class Profession < ApplicationRecord
  include SoftDeletable
  
  has_many :personals

  validates :name, presence: true, uniqueness: true

  def self.ransackable_attributes(auth_object = nil)
    ["name", "status", "created_at", "updated_at"]
  end
end
