class AddServiceChargePercentage < ActiveRecord::Migration
  def change
    add_column :loans, :service_charge_percentage, :float, default: 0.0
  end
end
