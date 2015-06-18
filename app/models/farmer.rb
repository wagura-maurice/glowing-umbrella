class Farmer < ActiveRecord::Base
  has_many :maize_reports, dependent: :destroy
  has_many :rice_reports, dependent: :destroy

  def self.new_farmer(session)
    f = Farmer.new
    f.phone_number = session[:phone_number]

    if session[:reporting_as] == "1"
      f.reporting_as = "individual"
      f.name = session[:name]
      f.national_id_number = session[:group_registration_number]
    elsif (session[:reporting_as] == "2") or (session[:national_id_number] == "2")
      f.reporting_as = "group"
      f.group_name = session[:group_name]
      f.group_registration_number = session[:group_registration_number]
    end
    
    f.association = session[:association]

    f.country = "Kenya"

    f.save
    return :home_menu
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

  def self.report_planting_or_harvesting(session)
    f = Farmer.where(phone_number: session[:phone_number]).first
    if session[:plant_or_harvest] == "1"
      case session[:crop_planted]
      when "1"
        MaizeReport.create(kg_of_seed_planted: session[:kg_planted], farmer: f, report_type: 'planting')
      when "2"
        RiceReport.create(kg_of_seed_planted: session[:kg_planted], farmer: f, report_type: 'planting')
      when "3"
        BeansReport.create(kg_of_seed_planted: session[:kg_planted], farmer: f, report_type: 'planting')
      when "4"
        GreenGramsReport.create(kg_of_seed_planted: session[:kg_planted], farmer: f, report_type: 'planting')
      when "5"
        BlackEyedBeansReport.create(kg_of_seed_planted: session[:kg_planted], farmer: f, report_type: 'planting')
      end
      return :home_menu
    elsif session[:plant_or_harvest] == "2"
      return :report_harvest
    end
  end


end
