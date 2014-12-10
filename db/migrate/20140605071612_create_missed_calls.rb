class CreateMissedCalls < ActiveRecord::Migration
  def change
    create_table :missed_calls do |t|
      t.uuid :channel_id
      t.uuid :subscriber_id
      t.datetime :time
      t.timestamps
    end
  end
end
