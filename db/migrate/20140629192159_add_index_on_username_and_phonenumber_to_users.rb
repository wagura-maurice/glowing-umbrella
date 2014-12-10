class AddIndexOnUsernameAndPhonenumberToUsers < ActiveRecord::Migration
  def change
    add_index :users, [:username, :phone_number]
  end
end
