class AddVehicleAndFuelToFuelOrders < ActiveRecord::Migration[7.1]
  def change
    add_reference :fuel_order_items, :fuel, null: false, foreign_key: true
    add_reference :fuel_order_items, :vehicle, null: true, foreign_key: true
  end
end
