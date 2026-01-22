class CreatePositions < ActiveRecord::Migration[8.0]
  def change
    create_table :positions do |t|
      t.string :name, null: false
      t.integer :department_id, null: false
      t.integer :gestion_id, null: false

      t.timestamps
    end

    add_index :positions, :department_id
    add_index :positions, :gestion_id
    add_foreign_key :positions, :departments, column: :department_id
    add_foreign_key :positions, :gestions, column: :gestion_id
  end
end
