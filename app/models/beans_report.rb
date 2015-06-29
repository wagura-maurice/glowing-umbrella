class BeansReport < ActiveRecord::Base
  belongs_to :farmer

  def self.new_report(session)
    r = BeansReport.new
    r.kg_of_seed_planted = session[:kg_of_maize_seed].to_f
    r.bags_harvested = session[:bags_harvested]
    r.grade_1_bags = session[:grade_1_bags]
    r.grade_2_bags = session[:grade_2_bags]
    r.ungraded_bags = session[:ungraded_bags]

    farmer = Farmer.where(phone_number: session[:phone_number]).first
    r.farmer = farmer

    r.save

    return :home_menu
  end
  
  def reporting_time
    self.created_at.strftime("%H:%M %p %d/%m/%y")
  end

end
