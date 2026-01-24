class CreateVehicles < ActiveRecord::Migration[7.1]
  def change
    create_table :vehicles do |t|
      t.string :plate
      t.text :description
      t.text :details
      t.references :vehicle_type, null: false, foreign_key: true

      t.timestamps
    end
  end
end
