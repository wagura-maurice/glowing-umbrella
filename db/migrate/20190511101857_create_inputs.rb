class CreateInputs < ActiveRecord::Migration
  def change
    create_table :inputs do |t|
    	t.string :crop_type
    	t.integer :bags_of_can_fertilizer
    	t.integer :season
    	t.belongs_to :farmer, index: true
    	t.timestamps null: false
    end
  end
end
