class CreateNotificationReads < ActiveRecord::Migration[8.0]
  def change
    create_table :notification_reads do |t|
      t.references :user, null: false, foreign_key: true
      t.references :gestion, null: false, foreign_key: true
      t.string :notification_type, null: false
      t.datetime :read_at, null: false

      t.timestamps
    end
    add_index :notification_reads, [:user_id, :gestion_id, :notification_type], unique: true, name: 'index_notification_reads_unique'
  end
end
