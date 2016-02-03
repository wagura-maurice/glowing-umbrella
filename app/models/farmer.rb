class Farmer < ActiveRecord::Base
  has_many :maize_reports, dependent: :destroy
  has_many :rice_reports, dependent: :destroy
  has_many :beans_reports, dependent: :destroy
  has_many :green_grams_reports, dependent: :destroy
  has_many :black_eyed_beans_reports, dependent: :destroy
  has_many :nerica_rice_reports, dependent: :destroy

  def self.new_farmer(session)
    f = Farmer.new
    f.phone_number = session[:phone_number]

#    if session[:reporting_as] == "1"
#      f.reporting_as = "individual"
#      f.name = session[:name]
#      f.national_id_number = session[:group_registration_number]
#    elsif (session[:reporting_as] == "2") or (session[:national_id_number] == "2")
#      f.reporting_as = "group"
#      f.group_name = session[:group_name]
#      f.group_registration_number = session[:group_registration_number]
#    end

    f.reporting_as = "individual"
    f.name = session[:name]
    f.national_id_number = session[:national_id_number]
    f.nearest_town = session[:nearest_town]
    f.county = session[:county]
    f.year_of_birth = session[:year_of_birth].to_i

    if session[:gender] == "1"
      f.gender = "male"
    elsif session[:gender] == "2"
      f.gender = "female"
    end

    f.association_name = session[:association_name]

    f.country = "Kenya"

    f.save
    return :home_menu
  end

  def self.report_planting_or_harvesting(session)
    f = Farmer.where(phone_number: session[:phone_number]).first
    if session[:plant_or_harvest] == "1"
      crop_planted = session[:planting_reports_available][session[:crop_planted].to_i]
      case crop_planted
      when :maize
        MaizeReport.create(kg_of_seed_planted: session[:kg_planted], farmer: f, report_type: 'planting')
      when :rice
        RiceReport.create(kg_of_seed_planted: session[:kg_planted], farmer: f, report_type: 'planting')
      when :nerica_rice
        NericaRiceReport.create(kg_of_seed_planted: session[:kg_planted], farmer: f, report_type: 'planting')
      when :beans
        BeansReport.create(kg_of_seed_planted: session[:kg_planted], farmer: f, report_type: 'planting')
      when :green_grams
        GreenGramsReport.create(kg_of_seed_planted: session[:kg_planted], farmer: f, report_type: 'planting')
      when :black_eyed_beans
        BlackEyedBeansReport.create(kg_of_seed_planted: session[:kg_planted], farmer: f, report_type: 'planting')
      end

      temp = Rails.cache.read(session[:phone_number])
      temp.delete(:planting_reports_available)
      Rails.cache.write(session[:phone_number], temp, expires_in: 12.hour)

      return :home_menu
    elsif session[:plant_or_harvest] == "2"
      return :report_harvest
    end
  end


  def registration_time
    self.created_at.strftime("%H:%M %p %d/%m/%y")
  end


  def display_name
    if self.name.present?
      return self.name
    else
      ""
    end
  end

end
