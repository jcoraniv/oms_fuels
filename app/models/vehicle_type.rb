class VehicleType < ApplicationRecord
  include SoftDeletable
  
  has_many :vehicles

  validates :name, presence: true
end
