class Farmer < ActiveRecord::Base
  has_many :maize_reports
  has_many :rice_reports

  def self.new_farmer(session)
    f = Farmer.new
    f.first_name = session[:first_name]
    f.last_name = session[:last_name]
    f.phone_number = session[:phone_number]
    f.national_id_number = session[:national_id_number]
    if session[:is_part_of_an_association] == "1"
      f.association = "true"
    elsif session[:is_part_of_an_association] == "2"
      f.association = "false"
    end
    f.county = session[:county]
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

end
