class AddStatusToVehicles < ActiveRecord::Migration[7.1]
  def change
    add_column :vehicles, :status, :string
  end
end
