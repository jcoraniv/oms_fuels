class AddCodeToPositions < ActiveRecord::Migration[8.0]
  def change
    add_column :positions, :code, :string
    add_index :positions, :code, unique: true
  end
end
