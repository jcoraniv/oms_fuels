class AddVehicleToFuelOrders < ActiveRecord::Migration[8.0]
  def up
    add_reference :fuel_orders, :vehicle, null: true, foreign_key: true
    
    # Asignar el primer vehículo disponible a órdenes existentes
    if Vehicle.any?
      default_vehicle = Vehicle.first
      FuelOrder.where(vehicle_id: nil).update_all(vehicle_id: default_vehicle.id)
    end
    
    change_column_null :fuel_orders, :vehicle_id, false
  end

  def down
    remove_reference :fuel_orders, :vehicle, foreign_key: true
  end
end
