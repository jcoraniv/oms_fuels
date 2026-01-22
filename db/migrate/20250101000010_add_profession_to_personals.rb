class AddProfessionToPersonals < ActiveRecord::Migration[8.0]
  def change
    add_reference :personals, :profession, null: true, foreign_key: true
  end
end
