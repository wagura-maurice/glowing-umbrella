class MaizeReport < ActiveRecord::Base
  belongs_to :farmer

  def self.new_report(session)
    r = MaizeReport.new
    r.acres_planted = session[:acres_of_maize].to_f
    r.kg_of_seed_planted = session[:kg_of_maize_seed].to_f
    
    case session[:type_of_maize]
    when "1"
      r.maize_type = "white"
    when "2"
      r.maize_type = "yellow"
    when "3"
      r.maize_type = "both"
    end

    case session[:maize_grade]
    when "1"
      r.grade = "1"
    when "2"
      r.grade = "2"
    when "3"
      r.grade = "3"
    when "4"
      r.grade = "ungraded"
    end

    r.bags_to_sell = session[:bags_to_sell].to_f
    r.kg_to_sell = session[:well_dried_maize_to_sell].to_f

    farmer = Farmer.where(phone_number: session[:phone_number]).first
    r.farmer = farmer

    r.save

  end

end
