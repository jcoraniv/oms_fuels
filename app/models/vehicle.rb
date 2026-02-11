class Vehicle < ApplicationRecord
  include SoftDeletable
  
  belongs_to :vehicle_type
  has_many :fuel_orders
  
  validates :plate, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["plate", "description", "details", "vehicle_type_id", "status", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["vehicle_type"]
  end
end
