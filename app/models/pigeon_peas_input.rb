class PigeonPeasInput < ActiveRecord::Base
	belongs_to :farmer

	include CropBase
	include Exportable

	default_scope lambda {
		where(season: $current_season)
	}

	before_create :set_season

	def set_season
		self.season = $current_season
	end

	def self.search_fields
		return {
			"created_at" => {type: :time, key: "Report Date", search_column: "pigeon_peas_inputs.created_at"},
			"kg_of_seed" => {type: :number, key: "KG of Seeds"},
			"bags_of_dap_fertilizer" => {type: :number, key: "Bags of DAP Fertilizer"},
			"bags_of_npk_fertilizer" => {type: :number, key: "Bags of NPK Fertilizer"},
			"bags_of_can_fertilizer" => {type: :number, key: "Bags of CAN Fertilizer"},
			"agro_chem" => {type: :string, key: "Agro Chemical"},
			"acres_planting" => {type: :number, key: "Acreage"},
			"season" => {type: :number, key: "Planting Season"}
		}
	end

	def self.new_input(session)
		r = PigeonPeasInput.new
		r.kg_of_seed = session[:kg_of_seed]
		r.bags_of_can_fertilizer = session[:bags_of_can_fertilizer]
	    if session[:bags_of_npk_fertilizer]	
	      r.bags_of_dap_fertilizer = ''	
	    else	
	      r.bags_of_dap_fertilizer = session[:bags_of_dap_fertilizer]	
	    end	
	    r.bags_of_npk_fertilizer = session[:bags_of_npk_fertilizer]	
	    r.agro_chem = session[:agro_chem]	
	    r.acres_planting = session[:acres_planting]
		r.season = $current_season
		r.farmer = Farmer.where(phone_number: session[:phone_number]).first
		r.save

		return :home_menu
	end
end
