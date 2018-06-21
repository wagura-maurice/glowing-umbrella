module UploadFarmerData
  extend self


  require 'roo'
  require 'aws_adapter'

  #################
  ### Constants ###
  #################
  @upload_start_row = 4
  @upload_end_row = 10000
  @will_upload_col = 19

  #######################
  ### Upload function ###
  #######################

  def upload(upload_path)
    sheet = get_first_sheet(upload_path)
    row = @upload_start_row
    errors = []
    count = 0
    while row <= @upload_end_row
      values = sheet.row(row)
      will_upload = will_upload?(values[@will_upload_col])
      if will_upload
        save_farmer(values, errors)
        count += 1
      end
      row += 1
    end

    return {errors: errors, tried: count}
  end

  ########################################
  ### Functions to create data records ###
  ########################################

  def save_farmer(farmer, errors)
    farmer_data = {
      name: farmer[1],
      phone_number: farmer[2].to_i.to_s,
      national_id_number: farmer[3].to_i.to_s,
      association_name: farmer[4].to_s,
      nearest_town: farmer[5].to_s,
      county: farmer[6].to_s,
      year_of_birth: farmer[7].to_i,
      gender: format_gender(farmer[8]),
      status: format_status(farmer[9]),
      country: "Kenya"
    }
    return if farmer_data[:national_id_number].nil?

    valid = true
    record_errors = []

    valid = validate :name, farmer_data[:name], record_errors, :any_letters
    valid = validate :phone_number, farmer_data[:phone_number], record_errors, :valid_phone_number
    valid = validate :national_id_number, farmer_data[:national_id_number], record_errors, :not_blank
    valid = validate :association_name, farmer_data[:association_name], record_errors, :not_blank
    valid = validate :nearest_town, farmer_data[:nearest_town], record_errors, :any_letters
    valid = validate :county, farmer_data[:county], record_errors, :any_letters
    valid = validate :year_of_birth, farmer_data[:year_of_birth], record_errors, :any_year
    valid = validate :gender, farmer_data[:gender], record_errors, :male_or_female
    valid = validate :status, farmer_data[:status], record_errors, :verified_or_pending

    if valid
      if Farmer.where(national_id_number: farmer_data[:national_id_number]).exists?
        record = Farmer.where(national_id_number: farmer_data[:national_id_number]).first
        return record.update_attributes(farmer_data)
      else
        return Farmer.create(farmer_data)
      end
    else
      errors << [farmer_data[:national_id_number], record_errors]
    end
  end

  def format_gender(val)
    if val.downcase[0] == 'm'
      return 'male'
    elsif val.downcase[0] == 'f'
      return 'female'
    else
      return ''
    end
  end

  def format_status(val)
    if val.downcase == 'verified'
      return 'verified'
    else
      return 'pending'
    end
  end

  ############################
  ### Validation functions ###
  ############################

  def validate(attr_name, value, errors, valid_responses)
    if valid_responses == :any
      return true
    elsif valid_responses == :any_number
      return value.scan(/[a-zA-Z]/).length == 0
    elsif valid_responses == :not_blank
      return value.present? && value.length > 0
    elsif valid_responses == :any_letters
      return value[/[a-zA-Z\s]+/] == value
    elsif valid_responses == :any_year
      res = value.to_i
      return res > 1950 && res < 2018
    elsif valid_responses == :male_or_female
      char = value.downcase[0]
      if (char == "m") || (char == "f")
        return true
      end
    elsif valid_responses == :verified_or_pending
      status = value.downcase
      if (status == "verified") || (status == "pending")
        return true
      end
    elsif valid_responses == :valid_phone_number
      if value.length == 9 && (value != '700000000')
        return true
      end
    else
      errors << "Farmer #{attr_name.to_s} is invalid"
      return false
    end
  end

  ##########################################
  ### Spreadsheet manipulation functions ###
  ##########################################

  def get_spreadsheet(upload_path)
    file_name = File.basename(upload_path) + '.xlsx'
    file_path = AwsAdapter.download_file(upload_path, 'tmp', file_name)
    xlsx = Roo::Spreadsheet.open(file_path)
    return xlsx
  end

  def get_first_sheet(upload_path)
    xlsx = get_spreadsheet(upload_path)
    first_sheet = xlsx.sheets.first
    sheet = xlsx.sheet(first_sheet)
    return sheet
  end

  def will_upload?(val)
    if val.nil?
      return false
    end
    return val.downcase == "true"
  end


end