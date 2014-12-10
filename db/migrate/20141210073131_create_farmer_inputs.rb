class CreateFarmerInputs < ActiveRecord::Migration
  def change
    create_table :farmer_inputs, id: :uuid do |t|
      t.integer :warehouse_number
      t.integer :commodity_number
      t.float :quantity
      t.integer :commodity_grade
      t.string :phone_number
      t.string :session_id
      t.integer :state
      t.timestamps
    end
  end
end
