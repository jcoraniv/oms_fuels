class Fuel < ApplicationRecord
  include SoftDeletable
  
  UNITS_OF_MEASURE = {
    liter: 'L',
    gallon: 'Gal',
    cubic_meter: 'm³',
    kilogram: 'Kg'
  }.freeze
  
  has_many :fuel_order_items

  validates :description, presence: true
  validates :unit_of_measure, presence: true, inclusion: { in: UNITS_OF_MEASURE.keys.map(&:to_s) }
  validates :reference_price, numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  def self.ransackable_attributes(auth_object = nil)
    ["description", "unit_of_measure", "reference_price", "status", "created_at", "updated_at"]
  end

  def description_with_unit
    unit_abbr = UNITS_OF_MEASURE[unit_of_measure.to_sym] || unit_of_measure
    "#{description} (#{unit_abbr})"
  end
end