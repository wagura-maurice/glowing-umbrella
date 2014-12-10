class CreatePublishers < ActiveRecord::Migration
  def change
    create_table :publishers, id: :uuid do |t|
      t.timestamps
    end

    add_column :users, :publisher_id, :uuid
  end
end
