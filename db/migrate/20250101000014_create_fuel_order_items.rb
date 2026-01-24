class CreateFuelOrderItems < ActiveRecord::Migration[8.0]
  def change
    create_table :fuel_order_items do |t|
      t.references :fuel_order, null: false, foreign_key: true
      t.decimal :quantity_ordered, precision: 10, scale: 2, null: false
      t.decimal :quantity_received, precision: 10, scale: 2
      t.decimal :unit_price, precision: 10, scale: 2, null: false
      t.decimal :partial_price, precision: 12, scale: 2
      t.decimal :received_price, precision: 12, scale: 2

      t.timestamps
    end
  end
end
