class ChangeNumberToIntegerInFuelOrders < ActiveRecord::Migration[8.0]
  def up
    change_column :fuel_orders, :number, 'integer USING CAST(number AS integer)'
  end

  def down
    change_column :fuel_orders, :number, :string
  end
end
