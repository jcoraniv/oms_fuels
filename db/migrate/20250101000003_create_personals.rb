class CreatePersonals < ActiveRecord::Migration[8.0]
  def change
    create_table :personals do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email
      t.string :phone
      t.string :ci, null: false

      t.timestamps
    end

    add_index :personals, :ci, unique: true
    add_index :personals, :email
  end
end
