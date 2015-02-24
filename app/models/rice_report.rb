class RiceReport < ActiveRecord::Base
  belongs_to :farmer

  def self.new_report(session)
    r = RiceReport.new
    r.acres_planted = session[:acres_of_rice].to_f
    r.kg_of_seed_planted = session[:kg_of_rice_seed].to_f
    r.kg_stored = session[:kg_of_rice_stored].to_f

    case session[:type_of_rice]
    when "1"
      r.rice_type = "paddy"
    when "2"
      r.rice_type = "non-paddy"
    when "3"
      r.rice_type = "both"
    end

    case session[:grain_type]
    when "1"
      r.grain_type = "long"
    when "2"
      r.grain_type = "short"
    when "3"
      r.grain_type = "broken"
    when "4"
      r.grain_type = "long and short"
    end

    case session[:rice_aroma]
    when "1"
      r.aroma_type = "aromatic"
    when "2"
      r.aroma_type = "non-aromatic"
    when "3"
      r.aroma_type = "both"
    end

    r.bags_to_sell = session[:bags_to_sell].to_f
    r.kg_to_sell = session[:well_dried_maize_to_sell].to_f
    
    farmer = Farmer.where(phone_number: session[:phone_number]).first
    r.farmer = farmer

    r.save

  end

end
