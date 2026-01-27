class Fuel < ApplicationRecord
  UNITS_OF_MEASURE = ['liter', 'gallon', 'cubic_meter', 'kilogram'].freeze

  validates :description, presence: true
  validates :unit_of_measure, presence: true, inclusion: { in: UNITS_OF_MEASURE.map(&:to_s) }
  validates :reference_price, numericality: { greater_than_or_equal_to: 0, allow_nil: true }
end