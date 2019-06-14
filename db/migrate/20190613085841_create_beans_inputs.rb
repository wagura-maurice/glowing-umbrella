class CreateBeansInputs < ActiveRecord::Migration
	def change
		create_table :beans_inputs do |t|
			t.integer :kg_of_seed
			t.integer :bags_of_dap_fertilizer
			t.integer :bags_of_npk_fertilizer
			t.integer :bags_of_can_fertilizer
			t.string :agro_chem
			t.integer :acres_planting
			t.integer :season
			t.belongs_to :farmer, index: true
			t.timestamps null: false
		end
	end
end
