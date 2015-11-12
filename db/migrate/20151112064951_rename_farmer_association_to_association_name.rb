class RenameFarmerAssociationToAssociationName < ActiveRecord::Migration
  def change
    rename_column :farmers, :association, :association_name
  end
end
