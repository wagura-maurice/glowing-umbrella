class AddApproxFarmerCount < ActiveRecord::Migration
  def change
    add_column :farmer_groups, :approx_farmer_count, :integer, default: 0.0

    FarmerGroup.all.each do |fg|
      puts fg.farmer_list.count
    end
  end
end
