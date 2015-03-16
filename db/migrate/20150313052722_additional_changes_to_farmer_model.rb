class AdditionalChangesToFarmerModel < ActiveRecord::Migration
  def change
    add_column :farmers, :reporting_as, :string
    add_column :farmers, :group_name, :string
    add_column :maize_reports, :bags_harvested, :float
    add_column :maize_reports, :grade_1_bags, :float
    add_column :maize_reports, :grade_2_bags, :float
    add_column :maize_reports, :ungraded_bags, :float
    add_column :rice_reports, :bags_harvested, :float
    add_column :rice_reports, :pishori_bags, :float
    add_column :rice_reports, :super_bags, :float
    add_column :rice_reports, :other_bags, :float
  end
end
