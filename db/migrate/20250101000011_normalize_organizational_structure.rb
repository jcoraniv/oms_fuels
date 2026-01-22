class NormalizeOrganizationalStructure < ActiveRecord::Migration[8.0]
  def change
    # 1. Drop the old join table
    drop_table :personal_positions

    # 2. Clean up the old master tables
    remove_column :departments, :parent_id, :integer
    remove_column :departments, :gestion_id, :integer
    remove_column :departments, :level, :integer

    remove_column :positions, :department_id, :integer
    remove_column :positions, :gestion_id, :integer

    # 3. Create the new structure tables
    create_table :org_structures do |t|
      t.references :gestion, null: false, foreign_key: true
      t.references :department, null: false, foreign_key: true
      t.references :parent_dept, foreign_key: { to_table: :org_structures }

      t.timestamps
    end

    create_table :org_positions do |t|
      t.references :org_structure, null: false, foreign_key: true
      t.references :position, null: false, foreign_key: true
      t.references :reports_to_position, foreign_key: { to_table: :org_positions }

      t.timestamps
    end

    # 4. Create the new assignment table
    create_table :assignments do |t|
      t.references :personal, null: false, foreign_key: true
      t.references :org_position, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
