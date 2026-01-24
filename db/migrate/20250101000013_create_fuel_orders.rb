class CreateFuelOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :fuel_orders do |t|
      t.string :number, null: false
      t.references :gestion, null: false, foreign_key: true
      t.references :requester_assignment, null: false, foreign_key: { to_table: :assignments }
      t.references :approver_assignment, foreign_key: { to_table: :assignments }
      t.decimal :total, precision: 12, scale: 2, default: 0.0
      t.string :status, default: 'pending', null: false
      t.datetime :approved_at
      t.datetime :completed_at
      t.datetime :canceled_at

      t.timestamps
    end

    add_index :fuel_orders, :number, unique: true
    add_index :fuel_orders, :status
  end
end
