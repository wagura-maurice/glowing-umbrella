class AddIndexToAssociationName < ActiveRecord::Migration
  def change
    add_index :farmers, :association_name
    add_index :farmers, :country
    add_index :farmers, :county
  end
end
