class Farmer < ActiveRecord::Base
  has_many :maize_reports, dependent: :destroy
  has_many :rice_reports, dependent: :destroy
  has_many :beans_reports, dependent: :destroy
  has_many :green_grams_reports, dependent: :destroy
  has_many :black_eyed_beans_reports, dependent: :destroy
  has_many :nerica_rice_reports, dependent: :destroy
  has_many :soya_beans_reports, dependent: :destroy
  has_many :pigeon_peas_reports, dependent: :destroy
  has_many :loans, dependent: :destroy

  include Exportable


  def self.search_fields
    return {"created_at" => {type: :time, key: "Registration Date"},
            "name" => {type: :string, key: "Name"},
            "nearest_town" => {type: :string, key: "Nearest Town"},
            "county" => {type: :string, key: "County"},
            "national_id_number" => {type: :string, key: "National ID"},
            "phone_number" => {type: :string, key: "Phone Number"},
            "association_name" => {type: :string, key: "Organization"},
            "year_of_birth" => {type: :number, key: "Year of Birth"},
            "gender" => {type: :select, key: "Gender", options: ['male', 'female']}
            }
  end

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

    country_code = f.phone_number[0..3]
    if country_code == "+254"
      f.country = "Kenya"
    elsif country_code == "+256"
      f.country = "Uganda"
    end

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
      when :soya_beans
        SoyaBeansReport.create(kg_of_seed_planted: session[:kg_planted], farmer: f, report_type: 'planting')
      when :pigeon_peas
        PigeonPeasReport.create(kg_of_seed_planted: session[:kg_planted], farmer: f, report_type: 'planting')
      end

      temp = Rails.cache.read(session[:phone_number])
      temp.delete(:planting_reports_available)
      Rails.cache.write(session[:phone_number], temp, expires_in: 12.hour)

      return :home_menu
    elsif session[:plant_or_harvest] == "2"
      return :report_harvest
    end
  end


  def self.save_pin(session)
    if session.has_key? :pin_value
      f = Farmer.where(phone_number: session[:phone_number]).first
      if f.national_id_number == session[:authenticated_national_id]
        f.accepted_loan_tnc = true
        f.pin = session[:pin_value]
        f.save
      end
    end
    return :loans_main_menu
  end


  def self.save_loan(session)
    f = Farmer.where(phone_number: session[:phone_number]).first

    if session.has_key?(:lima_loan_confirmation) && (session[:lima_loan_confirmation] == "1")
      Loan.create(farmer: f,
                  loan_type: 'lima',
                  amount: session[:lima_loan_amount],
                  season: $current_season,
                  disbursed_date: Time.now,
                  service_charge: 0.0,
                  disbursal_method: 'mpesa')

    elsif session.has_key?(:mavuno_loan_confirmation) && (session[:mavuno_loan_confirmation] == "1")
      Loan.create(farmer: f,
                  loan_type: 'mavuno',
                  amount: session[:mavuno_loan_amount],
                  season: $current_season,
                  disbursed_date: Time.now,
                  service_charge: 0.0,
                  disbursal_method: 'mpesa')

    elsif session.has_key?(:input_voucher_loan_confirmation) && (session[:input_voucher_loan_confirmation] == "1")
      code = f.generate_voucher_code(9)
      Loan.create(farmer: f,
                  loan_type: 'input_voucher',
                  amount: session[:input_voucher_loan_amount],
                  season: $current_season,
                  disbursed_date: Time.now,
                  service_charge: 0.0,
                  disbursal_method: 'mpesa',
                  voucher_code: code)
      msg = "Dear #{f.name}, your voucher number is #{code} \nPresent this voucher to the selected Agro dealers"
      if Rails.env.development?
        puts msg
      else
        SendMessages.send(f.phone_number, 'Jiunga', msg)
      end

    end

    return :home_menu
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

  # Generates a random string from a set of easily readable characters
  def generate_voucher_code(size = 9)
    charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
    code = (0...size).map{ charset.to_a[rand(charset.size)] }.join
    while Loan.where(loan_type: 'input_voucher', voucher_code: code).exists?
      code = (0...size).map{ charset.to_a[rand(charset.size)] }.join
    end
    return code
  end

end
