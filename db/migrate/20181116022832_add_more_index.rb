class AddMoreIndex < ActiveRecord::Migration
  def change
    add_index :farmers, :status
    add_index :farmers, :year_of_birth
    add_index :farmers, :gender
  end
end
