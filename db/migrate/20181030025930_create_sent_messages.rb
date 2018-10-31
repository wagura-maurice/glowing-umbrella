class CreateSentMessages < ActiveRecord::Migration
  def change
    create_table :sent_messages do |t|
      t.string :to, limit: 60
      t.string :from, limit: 60
      t.text :message
      t.integer :num_sent
      t.string :gender
      t.string :age_demographic
      t.string :country
      t.timestamps null: false
    end
  end
end
