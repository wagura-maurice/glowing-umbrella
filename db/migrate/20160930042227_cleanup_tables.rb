class CleanupTables < ActiveRecord::Migration
  def change
    drop_table :channels if table_exists? :channels
    drop_table :channels_subscribers if table_exists? :channels_subscribers
    drop_table :messages if table_exists? :messages
    drop_table :missed_calls if table_exists? :missed_calls
    drop_table :publishers if table_exists? :publishers
    drop_table :subscribers if table_exists? :subscribers
    remove_column :users, :publisher_id
    remove_column :users, :subscriber_id
  end


end
