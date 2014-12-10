class CreateChannelsSubscribersTable < ActiveRecord::Migration
  def change
    create_table :channels_subscribers, id: :uuid do |t|
    	t.uuid :channel_id
    	t.uuid :subscriber_id
    end
  end
end
