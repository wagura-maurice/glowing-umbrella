class ChangeFarmerStatusToString < ActiveRecord::Migration
  def change
    add_column :farmers, :new_status, :string

    Farmer.where(status: 0).update_all(new_status: 'pending')
    Farmer.where(status: 1).update_all(new_status: 'verified')

    remove_column :farmers, :status
    rename_column :farmers, :new_status, :status
  end
end
