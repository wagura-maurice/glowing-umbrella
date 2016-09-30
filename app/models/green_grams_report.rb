class GreenGramsReport < ActiveRecord::Base
  belongs_to :farmer
  has_one :planting_report, class_name: "GreenGramsReport", foreign_key: "harvest_report_id"
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
    return {"created_at" => {type: :time, key: "Report Date", search_column: "green_grams_reports.created_at"},
            "report_type" => {type: :select, key: "Report Type", options: ['planting', 'harvest']},
            "kg_of_seed_planted" => {type: :number, key: "KG of Seed Planted"},
            "bags_harvested" => {type: :number, key: "Bags Harvested"},
            "grade_1_bags" => {type: :number, key: "Grade 1 Bags"},
            "grade_2_bags" => {type: :number, key: "Grade 2 Bags"},
            "ungraded_bags" => {type: :number, key: "Ungraded Bags"},
            "farmers.name" => {type: :string, key: "Farmer Name"},
            "farmers.phone_number" => {type: :string, key: "Farmer Phone Number"},
            "farmers.association_name" => {type: :string, key: "Farmer Group Name"}
            }
  end

  def self.new_report(session)
    r = GreenGramsReport.new
    r.bags_harvested = session[:bags_harvested]
    r.grade_1_bags = session[:grade_1_bags]
    r.grade_2_bags = session[:grade_2_bags]
    r.ungraded_bags = session[:ungraded_bags]
    r.report_type = 'harvest'

    farmer = Farmer.where(phone_number: session[:phone_number]).first
    r.farmer = farmer

    last_planting_report = GreenGramsReport.where(farmer: farmer, report_type: 'planting').order(created_at: :desc).first
    if last_planting_report.present?
      r.planting_report = last_planting_report
    end

    r.save

    return :home_menu
  end

end
