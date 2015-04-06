class Farmer < ActiveRecord::Base
  has_many :maize_reports
  has_many :rice_reports

  def self.new_farmer(session)
    f = Farmer.new
    f.phone_number = session[:phone_number]

    if session[:reporting_as] == "1"
      f.reporting_as = "individual"
      f.first_name = session[:first_name]
      f.last_name = session[:last_name]
      f.national_id_number = session[:group_registration_number]
    elsif (session[:reporting_as] == "2") or (session[:national_id_number] == "2")
      f.reporting_as = "group"
      f.group_name = session[:group_name]
      f.group_registration_number = session[:group_registration_number]
    end
    
    f.association = session[:association]

    f.country = "Kenya"

    crops = []
    if session[:grows_maize] == "1"
      crops << "maize"
    end
    if session[:grows_rice] == "1"
      crops << "rice"
    end
    f.crops = crops

    f.save
  end

  def self.update_farmer_crop_report_values(session)
    f = Farmer.where(phone_number: session[:phone_number]).first
    crops = []
    if session[:grows_maize] == "1"
      crops << "maize"
    end
    if session[:grows_rice] == "1"
      crops << "rice"
    end
    f.crops = crops

    f.save
  end

end
