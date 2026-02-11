class RenameEmailToUsernameInUsers < ActiveRecord::Migration[8.0]
  def change
    rename_column :users, :email, :username
  end
end
