class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.integer :role_id, null: false
      t.integer :personal_id, null: false
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :role_id
    add_index :users, :personal_id
    add_foreign_key :users, :roles, column: :role_id
    add_foreign_key :users, :personals, column: :personal_id
  end
end
