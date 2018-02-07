class ChangeLoginPrimaryKey < ActiveRecord::Migration

  def change
    change_column_null :users, :email, false
    change_column_null :users, :phone_number, true
    change_column_null :users, :username, true
    add_index :users, :email
    remove_index :users, [:username, :phone_number]
  end
end
