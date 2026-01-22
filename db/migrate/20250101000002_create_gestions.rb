class CreateGestions < ActiveRecord::Migration[8.0]
  def change
    create_table :gestions do |t|
      t.string :code, null: false
      t.string :name, null: false
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :gestions, :code, unique: true
  end
end
