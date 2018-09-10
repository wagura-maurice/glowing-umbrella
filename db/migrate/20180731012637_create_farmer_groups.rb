class CreateFarmerGroups < ActiveRecord::Migration
  def change
    add_index :farmers, :group_name

    create_table :farmer_groups do |t|
      t.string :group_name
      t.string :short_names
      t.string :formal_name
      t.integer :registration_number
      t.string :country
      t.string :county
      t.string :sub_county
      t.string :location
      t.text :store_aggregation_center
      t.text :machinery
      t.text :other_buildings
      t.text :motor_vehicles
      t.string :audited_financials_upload_path
      t.string :management_accounts_upload_path
      t.string :certificate_of_registration_upload_path
      t.string :chairman_name
      t.string :chairman_phone_number
      t.string :chairman_email
      t.string :vice_chairman_name
      t.string :vice_chairman_phone_number
      t.string :vice_chairman_email
      t.string :secretary_name
      t.string :secretary_phone_number
      t.string :secretary_email
      t.string :treasurer_name
      t.string :treasurer_phone_number
      t.string :treasurer_email
      t.float :aggregated_harvest_data
      t.float :total_harvest_collected_for_sale
      t.timestamps null: false
    end

    add_index :farmer_groups, :group_name
  end
end
