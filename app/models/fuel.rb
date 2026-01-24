class Fuel < ApplicationRecord
  UNITS_OF_MEASURE = ['liter', 'gallon', 'cubic_meter', 'kilogram'].freeze

  validates :description, presence: true
  validates :unit_of_measure, presence: true, inclusion: { in: UNITS_OF_MEASURE.map(&:to_s) }
end