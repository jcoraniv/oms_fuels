class VehicleType < ApplicationRecord
  include SoftDeletable
  
  has_many :vehicles

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["name", "description", "status", "created_at", "updated_at"]
  end
end
