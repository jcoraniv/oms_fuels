class FixFuelOrdersNumberIndex < ActiveRecord::Migration[8.0]
  def change
    remove_index :fuel_orders, :number
    add_index :fuel_orders, [:number, :gestion_id], unique: true
  end
end
