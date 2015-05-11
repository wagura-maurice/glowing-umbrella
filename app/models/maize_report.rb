class MaizeReport < ActiveRecord::Base
  belongs_to :farmer

  def self.new_report(session)
    r = MaizeReport.new
    r.kg_of_seed_planted = session[:kg_of_maize_seed].to_f
    r.bags_harvested = session[:bags_harvested]
    r.grade_1_bags = session[:grade_1_bags]
    r.grade_2_bags = session[:grade_2_bags]
    r.ungraded_bags = session[:ungraded_bags]

    farmer = Farmer.where(phone_number: session[:phone_number]).first
    r.farmer = farmer

    r.save

  end

  def reporting_time
    self.created_at.strftime("%H:%M %p %d/%m/%y")
  end



end
