class Vehicle < ApplicationRecord
  include SoftDeletable
  
  belongs_to :vehicle_type
  has_many :fuel_orders
  
  validates :plate, presence: true
end
