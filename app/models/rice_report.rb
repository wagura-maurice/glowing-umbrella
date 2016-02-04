class RiceReport < ActiveRecord::Base
  belongs_to :farmer
  has_one :planting_report, class_name: "RiceReport", foreign_key: "harvest_report_id"
  belongs_to :harvest_report

  include CropBase
  include Exportable

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

    r.save

    return :home_menu
  end

end
