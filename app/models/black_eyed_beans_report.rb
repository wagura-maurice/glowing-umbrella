class BlackEyedBeansReport < ActiveRecord::Base
  belongs_to :farmer
  has_one :planting_report, class_name: "BlackEyedBeansReport", foreign_key: "harvest_report_id"
  belongs_to :harvest_report

  def self.new_report(session)
    r = BlackEyedBeansReport.new
    r.bags_harvested = session[:bags_harvested]
    r.grade_1_bags = session[:grade_1_bags]
    r.grade_2_bags = session[:grade_2_bags]
    r.ungraded_bags = session[:ungraded_bags]
    r.report_type = 'harvest'

    farmer = Farmer.where(phone_number: session[:phone_number]).first
    r.farmer = farmer

    last_planting_report = BlackEyedBeansReport.where(farmer: farmer, report_type: 'planting').order(created_at: :desc).first
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
