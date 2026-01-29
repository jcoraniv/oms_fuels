class ChangeUsersActiveToStatus < ActiveRecord::Migration[8.0]
  def up
    add_column :users, :status, :integer, default: 0, null: false
    
    # Migrate existing data
    User.reset_column_information
    User.find_each do |user|
      user.update_column(:status, user.active? ? 0 : 1)
    end
    
    remove_column :users, :active
  end

  def down
    add_column :users, :active, :boolean, default: true
    
    # Migrate data back
    User.reset_column_information
    User.find_each do |user|
      user.update_column(:active, user.status == 0)
    end
    
    remove_column :users, :status
  end
end
