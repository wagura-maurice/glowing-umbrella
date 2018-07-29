module UploadCropData
  extend self


  require 'roo'
  require 'aws_adapter'

  #################
  ### Constants ###
  #################
  @upload_start_row = 4
  @upload_end_row = 10000
  @will_upload_col = 16

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
        save_crop(values, errors)
        count += 1
      end
      row += 1
    end
    puts "ERRORS: #{errors}"
    puts "TRIED: #{count}"
    return {errors: errors, tried: count}
  end

  ########################################
  ### Functions to create data records ###
  ########################################

  def save_crop(crop, errors)
    crop_type = crop[2].to_s
    crop_report_number = crop[0].to_i.to_s

    crop_data = {
      report_type: crop[1].to_s,
      kg_of_seed_planted: crop[3].to_i,
      bags_harvested: crop[4].to_i,
      grade_1_bags: crop[5].to_i,
      grade_2_bags: crop[6].to_i,
      farmer_id: crop[7].to_i.to_s
    }
    crop_data[:ungraded_bags] = crop_data[:bags_harvested] - crop_data[:grade_1_bags] - crop_data[:grade_2_bags]

    valid = true
    record_errors = []

    valid = validate :report_type, crop_data[:report_type], record_errors, :planting_or_harvesting, crop_report_number
    puts "VALID: #{valid}"
    unless Farmer.where(national_id_number: crop_data[:farmer_id]).exists?
      valid = false
      record_errors << "Crop report #{crop_report_number} farmer_id is not valid"
      puts "NOT VALID"
    end


    if valid
      crop_model = get_crop_model(crop_type)
      crop_model.create(crop_data)
    else
      errors << [crop_report_number, record_errors]
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

  def get_crop_model(str)
    val = str.downcase
    if val == 'maize'
      return MaizeReport
    elsif val == 'rice'
      return RiceReport
    elsif val == 'beans'
      return BeansReport
    elsif val == 'green grams'
      return GreenGramsReport
    elsif val == 'black eyed beans'
      return BlackEyedBeansReport
    elsif val == 'soya beans'
      return SoyaBeansReport
    elsif val == 'pigeon peas'
      return PigeonPeasReport
    end
  end

  ############################
  ### Validation functions ###
  ############################

  def validate(attr_name, value, errors, valid_responses, crop_report_number)
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
    elsif valid_responses == :planting_or_harvesting
      report = value.downcase
      if (report == "planting") || (report == "harvesting")
        return true
      end
      return false
    elsif valid_responses == :verified_or_pending
      status = value.downcase
      if (status == "verified") || (status == "pending")
        return true
      end
    elsif valid_responses == :valid_phone_number
      if value.length == 9 && (value != '700000000')
        return true
      end
    elsif valid_responses == :valid_planting
      res = value.to_i
      return res > 0 && res < 100000
    elsif valid_responses == :valid_harvesting
      res = value.to_i
      return res > 0 && res < 10000
    else
      errors << "Crop Report #{crop_report_number} #{attr_name.to_s} is invalid"
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