class NericaRiceReport < ActiveRecord::Base
  belongs_to :farmer
  has_one :planting_report, class_name: "NericaRiceReport", foreign_key: "harvest_report_id"
  belongs_to :harvest_report

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
    return {"created_at" => {type: :time, key: "Report Date", search_column: "nerica_rice_reports.created_at"},
            "report_type" => {type: :select, key: "Report Type", options: ['planting', 'harvest']},
            "kg_of_seed_planted" => {type: :number, key: "KG of Seed Planted"},
            "bags_harvested" => {type: :number, key: "Bags Harvested"},
            "pishori_bags" => {type: :number, key: "Pishori Bags"},
            "super_bags" => {type: :number, key: "Super Bags"},
            "other_bags" => {type: :number, key: "Other Bags"},
            "farmers.name" => {type: :string, key: "Farmer Name"},
            "farmers.phone_number" => {type: :string, key: "Farmer Phone Number"},
            "farmers.association_name" => {type: :string, key: "Farmer Group Name"}
            }
  end

  def self.new_report(session)
    r = NericaRiceReport.new
    r.bags_harvested = session[:bags_harvested]
    r.pishori_bags = session[:pishori_bags]
    r.super_bags = session[:super_bags]
    r.other_bags = session[:other_bags]
    r.report_type = 'harvest'

    farmer = Farmer.where(phone_number: session[:phone_number]).first
    r.farmer = farmer

    last_planting_report = NericaRiceReport.where(farmer: farmer, report_type: 'planting').order(created_at: :desc).first
    if last_planting_report.present?
      r.planting_report = last_planting_report
    end

    r.save unless session[:dont_perform_new_report_in_request]

    return :home_menu
  end

  def self.input_report(session)
    r = Input.new
    r.crop_type = 'nerica_rice'
    r.kg_of_seed = session[:kg_of_seed]
    r.kg_of_can_fertilizer = session[:bags_of_can_fertilizer]
    if session[:bags_of_npk_fertilizer]
      r.kg_of_dap_fertilizer = ''
    else
      r.kg_of_dap_fertilizer = session[:bags_of_dap_fertilizer]
    end
    r.kg_of_npk_fertilizer = session[:bags_of_npk_fertilizer]
    r.agro_chem = session[:agro_chem]
    r.acres_planting = session[:acres_planting]
    r.season = $current_season
    r.farmer = Farmer.where(phone_number: session[:phone_number]).first
    r.save

    return :home_menu
  end

end
