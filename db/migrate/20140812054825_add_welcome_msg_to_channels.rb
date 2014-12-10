class AddWelcomeMsgToChannels < ActiveRecord::Migration
  def change
    add_column :channels, :subscribe_message, :text
    add_column :channels, :unsubscribe_message, :text
  end
end
