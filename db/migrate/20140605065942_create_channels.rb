class CreateChannels < ActiveRecord::Migration
  def change
    create_table :channels, id: :uuid do |t|
      t.string :channel_type, default: 'phone_number'
      t.string :phone_number
      t.string :status, default: 'created'
      t.string :name
      t.uuid :publisher_id
      t.timestamps
    end
  end
end
