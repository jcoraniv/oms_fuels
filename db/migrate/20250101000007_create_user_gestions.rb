class CreateUserGestions < ActiveRecord::Migration[8.0]
  def change
    create_table :user_gestions do |t|
      t.integer :user_id, null: false
      t.integer :gestion_id, null: false
      t.boolean :current, default: false

      t.timestamps
    end

    add_index :user_gestions, :user_id
    add_index :user_gestions, :gestion_id
    add_index :user_gestions, [:user_id, :gestion_id], unique: true
    add_foreign_key :user_gestions, :users, column: :user_id
    add_foreign_key :user_gestions, :gestions, column: :gestion_id
  end
end
