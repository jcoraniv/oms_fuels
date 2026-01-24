class FuelOrderItem < ApplicationRecord
  belongs_to :fuel_order
  belongs_to :fuel
  belongs_to :vehicle, optional: true

  validates :quantity_ordered, presence: true, numericality: { greater_than: 0 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_save :calculate_prices

  private

  def calculate_prices
    self.partial_price = (quantity_ordered || 0) * (unit_price || 0)
    
    if quantity_received.present?
      # Assuming unit_price is used for received calculation as well, 
      # unless we add a specific unit_price_at_delivery column later.
      self.received_price = quantity_received * unit_price
    end
  end
end
