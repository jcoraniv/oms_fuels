class CreateDepartments < ActiveRecord::Migration[8.0]
  def change
    create_table :departments do |t|
      t.string :name, null: false
      t.integer :level, null: false
      t.integer :parent_id
      t.integer :gestion_id, null: false

      t.timestamps
    end

    add_index :departments, :parent_id
    add_index :departments, :gestion_id
    add_foreign_key :departments, :departments, column: :parent_id
    add_foreign_key :departments, :gestions, column: :gestion_id
  end
end
