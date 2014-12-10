class CreateSubscribers < ActiveRecord::Migration
  def change
    create_table :subscribers, id: :uuid do |t|
      t.string :phone_number
      t.timestamps
    end

      add_column :users, :subscriber_id, :uuid
  end
end
