class AddStatusToMultipleTables < ActiveRecord::Migration[8.0]
  def up
    add_column :vehicles, :status, :integer, default: 0, null: false unless column_exists?(:vehicles, :status)
    add_column :fuels, :status, :integer, default: 0, null: false unless column_exists?(:fuels, :status)
    add_column :departments, :status, :integer, default: 0, null: false unless column_exists?(:departments, :status)
    add_column :personals, :status, :integer, default: 0, null: false unless column_exists?(:personals, :status)
    add_column :professions, :status, :integer, default: 0, null: false unless column_exists?(:professions, :status)
    add_column :vehicle_types, :status, :integer, default: 0, null: false unless column_exists?(:vehicle_types, :status)
    add_column :gestions, :status, :integer, default: 0, null: false unless column_exists?(:gestions, :status)
    
    # Convert vehicles status from string to integer if exists as string
    if column_exists?(:vehicles, :status) && columns(:vehicles).find { |c| c.name == 'status' }.type == :string
      execute <<-SQL
        ALTER TABLE vehicles ALTER COLUMN status TYPE integer USING 
        CASE 
          WHEN status = 'active' THEN 0 
          WHEN status = 'inactive' THEN 1 
          ELSE 0 
        END;
      SQL
    end
  end

  def down
    remove_column :gestions, :status if column_exists?(:gestions, :status)
    remove_column :vehicle_types, :status if column_exists?(:vehicle_types, :status)
    remove_column :professions, :status if column_exists?(:professions, :status)
    remove_column :personals, :status if column_exists?(:personals, :status)
    remove_column :departments, :status if column_exists?(:departments, :status)
    remove_column :fuels, :status if column_exists?(:fuels, :status)
    remove_column :vehicles, :status if column_exists?(:vehicles, :status)
  end
end
