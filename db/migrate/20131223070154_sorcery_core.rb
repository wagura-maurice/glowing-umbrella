class SorceryCore < ActiveRecord::Migration
  def self.up
    enable_extension 'uuid-ossp'
    
    create_table :sessions do |t|
      t.uuid :session_id, :null => false
      t.text :data
      t.timestamps
    end

    add_index :sessions, :session_id
    add_index :sessions, :updated_at

    create_table :users, id: :uuid do |t|
      t.string :phone_number,     :default => nil, :null => false
      t.string :email,            :default => nil # if you use this field as a username, you might want to make it :null => false.
      t.string :crypted_password, :default => nil
      t.string :salt,             :default => nil
      t.string :first_name,       :default => nil
      t.string :last_name,        :default => nil
      t.string :country,          :default => nil, :null => false
      t.string :username,         :default => nil, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end