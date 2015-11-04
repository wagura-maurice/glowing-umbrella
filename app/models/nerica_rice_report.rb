class NericaRiceReport < ActiveRecord::Base
  belongs_to :farmer
  has_one :planting_report, class_name: "NericaRiceReport", foreign_key: "harvest_report_id"
  belongs_to :harvest_report

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

    r.save

    return :home_menu
  end


  def reporting_time
    self.created_at.strftime("%H:%M %p %d/%m/%y")
  end

end
