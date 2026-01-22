class CreatePersonalPositions < ActiveRecord::Migration[8.0]
  def change
    create_table :personal_positions do |t|
      t.integer :personal_id, null: false
      t.integer :position_id, null: false
      t.integer :gestion_id, null: false
      t.date :start_date
      t.date :end_date

      t.timestamps
    end

    add_index :personal_positions, :personal_id
    add_index :personal_positions, :position_id
    add_index :personal_positions, :gestion_id
    add_foreign_key :personal_positions, :personals, column: :personal_id
    add_foreign_key :personal_positions, :positions, column: :position_id
    add_foreign_key :personal_positions, :gestions, column: :gestion_id
  end
end
