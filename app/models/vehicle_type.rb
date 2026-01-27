class VehicleType < ApplicationRecord
  has_many :vehicles

  validates :name, presence: true
end
