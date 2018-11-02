class RiceReport < ActiveRecord::Base
  belongs_to :farmer
  has_one :planting_report, class_name: "RiceReport", foreign_key: "harvest_report_id"
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
    return {"created_at" => {type: :time, key: "Report Date", search_column: "rice_reports.created_at"},
            "report_type" => {type: :select, key: "Report Type", options: ['planting', 'harvest']},
            "kg_of_seed_planted" => {type: :number, key: "KG of Seed Planted"},
            "kg_of_fertilizer" => {type: :number, key: "KG of Fertilizer Planted"},
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
    r = RiceReport.new
    r.bags_harvested = session[:bags_harvested]
    r.pishori_bags = session[:pishori_bags]
    r.super_bags = session[:super_bags]
    r.other_bags = session[:other_bags]
    r.report_type = 'harvest'

    farmer = Farmer.where(phone_number: session[:phone_number]).first
    r.farmer = farmer

    last_planting_report = RiceReport.where(farmer: farmer, report_type: 'planting').order(created_at: :desc).first
    if last_planting_report.present?
      r.planting_report = last_planting_report
    end

    r.save unless session[:dont_perform_new_report_in_request]

    return :home_menu
  end

end
