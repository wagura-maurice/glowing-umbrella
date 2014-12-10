class AddUserIdToFarmerInput < ActiveRecord::Migration
  def change
    add_column :farmer_inputs, :user_id, :uuid
  end
end
