class AddStatusToFarmers < ActiveRecord::Migration
  def change
    add_column :farmers, :status, :integer, default: 0
  end
end
