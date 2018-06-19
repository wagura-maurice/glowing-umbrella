class AddFarmSizeToFarmer < ActiveRecord::Migration
  def change
    add_column :farmers, :farm_size, :float
  end
end
