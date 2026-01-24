class CreateFuels < ActiveRecord::Migration[7.1]
  def change
    create_table :fuels do |t|
      t.string :description
      t.string :unit_of_measure

      t.timestamps
    end
  end
end
