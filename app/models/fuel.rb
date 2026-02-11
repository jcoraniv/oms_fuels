class Fuel < ApplicationRecord
  include SoftDeletable
  
  UNITS_OF_MEASURE = ['liter', 'gallon', 'cubic_meter', 'kilogram'].freeze
  
  has_many :fuel_order_items

  validates :description, presence: true
  validates :unit_of_measure, presence: true, inclusion: { in: UNITS_OF_MEASURE.map(&:to_s) }
  validates :reference_price, numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  def self.ransackable_attributes(auth_object = nil)
    ["description", "unit_of_measure", "reference_price", "status", "created_at", "updated_at"]
  end
end