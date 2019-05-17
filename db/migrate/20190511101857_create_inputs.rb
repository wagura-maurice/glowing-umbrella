class CreateInputs < ActiveRecord::Migration
  def change
    create_table :inputs do |t|
    	t.string :crop_type
    	t.integer :kg_of_seed
    	t.integer :kg_of_can_fertilizer
        t.integer :kg_of_dap_fertilizer
        t.integer :kg_of_npk_fertilizer
        t.string :agro_chem
    	t.integer :acres_planting
    	t.integer :season
    	t.belongs_to :farmer, index: true
    	t.timestamps null: false
    end
  end
end
