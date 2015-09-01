class NericaRiceReport < ActiveRecord::Base
  belongs_to :farmer


  def self.new_report(session)
    r = NericaRiceReport.new
    r.kg_of_seed_planted = session[:kg_of_rice_seed].to_f

    r.bags_harvested = session[:bags_harvested]
    r.pishori_bags = session[:pishori_bags]
    r.super_bags = session[:super_bags]
    r.other_bags = session[:other_bags]

    farmer = Farmer.where(phone_number: session[:phone_number]).first
    r.farmer = farmer

    r.save

    return :home_menu
  end


  def reporting_time
    self.created_at.strftime("%H:%M %p %d/%m/%y")
  end

end
