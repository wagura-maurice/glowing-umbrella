class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages, id: :uuid do |t|
    	t.string :direction
    	t.boolean :read
    	t.string :to
    	t.string :from
    	t.text :content
    	t.datetime :time
    	t.datetime :time_read
    	t.uuid :channel_id
      t.timestamps
    end
  end
end
