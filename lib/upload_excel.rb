module UploadExcel
  extend self

  # Required libraries
  require 'roo'
  require 'dropbox_sdk'

  #################
  ### Constants ###
  #################
  @upload_excel_name = "upload.xlsx"
  @dropbox_path = '/Egranary/upload_files/'
  @sheet_name = "Upload"
  @will_upload_row = 0
  @upload_start_row = 3
  @upload_end_row = 10000


  @farmer_start = 1
  @farmer_end = 8
  @maize_planting_start = 14
  @maize_planting_end = 14
  @maize_harvest_start = 15
  @maize_harvest_end = 18
  @rice_planting_start = 25
  @rice_planting_end = 25
  @rice_harvest_start = 26
  @rice_harvest_end = 29
  @nerica_planting_start = 36
  @nerica_planting_end = 36
  @nerica_harvest_start = 37
  @nerica_harvest_end = 40
  @beans_planting_start = 47
  @beans_planting_end = 47
  @beans_harvest_start = 48
  @beans_harvest_end = 51
  @green_grams_planting_start = 58
  @green_grams_planting_end = 58
  @green_grams_harvest_start = 59
  @green_grams_harvest_end = 62
  @black_eyed_beans_planting_start = 69
  @black_eyed_beans_planting_end = 69
  @black_eyed_beans_harvest_start = 70
  @black_eyed_beans_harvest_end = 73


  #######################
  ### Upload function ###
  #######################

  def upload
    sheet = get_sheet
    row = @upload_start_row
    while row <= @upload_end_row
      value = sheet.row(row)
      will_upload = will_upload?(value[@will_upload_row])
      if will_upload
        save_record(value)
      end
      row += 1
    end
  end


  ##########################################
  ### Spreadsheet manipulation functions ###
  ##########################################

  def get_sheet
    xlsx = get_spreadhseet
    sheet = xlsx.sheet(@sheet_name)
    return sheet
  end


  def get_spreadhseet
    login_to_dropbox
    download_file
    xlsx = Roo::Spreadsheet.open(get_file_path_for_download)
    return xlsx
  end

  def will_upload?(val)
    return val.downcase == "true"
  end

  ###############################
  ### File download functions ###
  ###############################

  def login_to_dropbox
    flow = DropboxOAuth2FlowNoRedirect.new(ENV['DROPBOX_KEY'], ENV['DROPBOX_SECRET'])
    authorize_url = flow.start()
    puts '1. Go to: ' + authorize_url
    puts '2. Click "Allow" (you might have to log in first)'
    puts '3. Copy the authorization code'
    print 'Enter the authorization code here: '
    code = gets.strip
    access_token, user_id = flow.finish(code)
    @client = DropboxClient.new(access_token)
  end

  def download_file
    contents, metadata = @client.get_file_and_metadata(@dropbox_path + @upload_excel_name)
    File.open(get_file_path_for_download, 'wb') do |file|
      file.write(contents)
    end
  end

  def get_file_path_for_download
    Rails.root.join('tmp').to_s + '/' + @upload_excel_name
  end

  ########################################
  ### Functions to create data records ###
  ########################################

  def save_record(value)
    farmer = value[@farmer_start..@farmer_end]
    maize_planting = value[@maize_planting_start..@maize_planting_end]
    maize_harvest = value[@maize_harvest_start..@maize_harvest_end]
    rice_planting = value[@rice_planting_start..@rice_planting_end]
    rice_harvest = value[@rice_harvest_start..@rice_harvest_end]
    nerica_planting = value[@nerica_planting_start..@nerica_planting_end]
    nerica_harvest = value[@nerica_harvest_start..@nerica_harvest_end]
    beans_planting = value[@beans_planting_start..@beans_planting_end]
    beans_harvest = value[@beans_harvest_start..@beans_harvest_end]
    green_grams_planting = value[@green_grams_planting_start..@green_grams_planting_end]
    green_grams_harvest = value[@green_grams_harvest_start..@green_grams_harvest_end]
    black_eyed_beans_planting = value[@black_eyed_beans_planting_start..@black_eyed_beans_planting_end]
    black_eyed_beans_harvest = value[@black_eyed_beans_harvest_start..@black_eyed_beans_harvest_end]

    if (@farmer = save_farmer(farmer))
      @maize_planting = save_maize_planting(maize_planting, @farmer)
      @maize_harvest = save_maize_harvest(maize_harvest, @farmer)
      @rice_planting = save_rice_planting(rice_planting, @farmer)
      @rice_harvest = save_rice_harvest(rice_harvest, @farmer)
      @nerica_planting = save_nerica_planting(nerica_planting, @farmer)
      @nerica_harvest = save_nerica_harvest(nerica_harvest, @farmer)
      @beans_planting = save_beans_planting(beans_planting, @farmer)
      @beans_harvest = save_beans_harvest(beans_harvest, @farmer)
      @green_grams_planting = save_green_grams_planting(green_grams_planting, @farmer)
      @green_grams_harvest = save_green_grams_harvest(green_grams_harvest, @farmer)
      @black_eyed_beans_planting = save_black_eyed_beans_planting(black_eyed_beans_planting, @farmer)
      @black_eyed_beans_harvest = save_black_eyed_beans_harvest(black_eyed_beans_harvest, @farmer)
    end
  end


  @phone_number = 0
  @name = 1
  @id_number = 2
  @group_name = 3
  @group_registration = 4
  @national_association = 5
  @town = 6
  @county = 7

  def save_farmer(farmer)
    phone_number = "+254" + farmer[@phone_number].to_i.to_s
    name = farmer[@name]
    id_number = farmer[@id_number]
    group_name = farmer[@group_name]
    group_registration = farmer[@group_registration]
    national_association = farmer[@national_association]
    town = farmer[@town]
    county = farmer[@county]

    if group_name.nil?
      reporting_as = "individual"
    else
      reporting_as = "group"
    end

    country = "Kenya"

    if Farmer.where(phone_number: phone_number).exists?
      return Farmer.where(phone_number: phone_number).first
    else
      return Farmer.create(phone_number: phone_number,
                           name: name,
                           national_id_number: id_number,
                           association: national_association,
                           country: country,
                           county: county,
                           nearest_town: town,
                           reporting_as: reporting_as,
                           group_name: group_name,
                           group_registration_number: group_registration)
    end
  end


  def save_maize_planting(maize_planting, farmer)
    kg_planted = maize_planting[0]
    return if kg_planted.nil?
    MaizeReport.create(kg_of_seed_planted: kg_planted, farmer: farmer, report_type: 'planting')
  end


  def save_maize_harvest(maize_harvest, farmer)
    bags_harvested = maize_harvest[0]
    grade_1_bags = maize_harvest[1]
    grade_2_bags = maize_harvest[2]
    ungraded_bags = maize_harvest[3]
    report_type = 'harvest'
    return if bags_harvested.nil?
    MaizeReport.create(bags_harvested: bags_harvested, grade_1_bags: grade_1_bags, grade_2_bags: grade_2_bags, ungraded_bags: ungraded_bags, report_type: report_type, farmer: farmer)
  end


  def save_rice_planting(rice_planting, farmer)
    kg_planted = rice_planting[0]
    return if kg_planted.nil?
    RiceReport.create(kg_of_seed_planted: kg_planted, farmer: farmer, report_type: 'planting')
  end


  def save_rice_harvest(rice_harvest, farmer)
    bags_harvested = rice_harvest[0]
    pishori_bags = rice_harvest[1]
    super_bags = rice_harvest[2]
    other_bags = rice_harvest[3]
    report_type = 'harvest'
    return if bags_harvested.nil?
    RiceReport.create(bags_harvested: bags_harvested, pishori_bags: pishori_bags, super_bags: super_bags, other_bags: other_bags, report_type: report_type, farmer: farmer)
  end


  def save_nerica_planting(nerica_planting, farmer)
    kg_planted = nerica_planting[0]
    return if kg_planted.nil?
    NericaRiceReport.create(kg_of_seed_planted: kg_planted, farmer: farmer, report_type: 'planting')
  end


  def save_nerica_harvest(nerica_harvest, farmer)
    bags_harvested = nerica_harvest[0]
    pishori_bags = nerica_harvest[1]
    super_bags = nerica_harvest[2]
    other_bags = nerica_harvest[3]
    report_type = 'harvest'
    return if bags_harvested.nil?
    NericaRiceReport.create(bags_harvested: bags_harvested, pishori_bags: pishori_bags, super_bags: super_bags, other_bags: other_bags, report_type: report_type, farmer: farmer)
  end


  def save_beans_planting(beans_planting, farmer)
    kg_planted = beans_planting[0]
    return if kg_planted.nil?
    BeansReport.create(kg_of_seed_planted: kg_planted, farmer: farmer, report_type: 'planting')
  end


  def save_beans_harvest(beans_harvest, farmer)
    bags_harvested = beans_harvest[0]
    grade_1_bags = beans_harvest[1]
    grade_2_bags = beans_harvest[2]
    ungraded_bags = beans_harvest[3]
    report_type = 'harvest'
    return if bags_harvested.nil?
    BeansReport.create(bags_harvested: bags_harvested, grade_1_bags: grade_1_bags, grade_2_bags: grade_2_bags, ungraded_bags: ungraded_bags, report_type: report_type, farmer: farmer)
  end


  def save_green_grams_planting(green_grams_planting, farmer)
    kg_planted = green_grams_planting[0]
    return if kg_planted.nil?
    GreenGramsReport.create(kg_of_seed_planted: kg_planted, farmer: farmer, report_type: 'planting')
  end


  def save_green_grams_harvest(green_grams_harvest, farmer)
    bags_harvested = green_grams_harvest[0]
    grade_1_bags = green_grams_harvest[1]
    grade_2_bags = green_grams_harvest[2]
    ungraded_bags = green_grams_harvest[3]
    report_type = 'harvest'
    return if bags_harvested.nil?
    GreenGramsReport.create(bags_harvested: bags_harvested, grade_1_bags: grade_1_bags, grade_2_bags: grade_2_bags, ungraded_bags: ungraded_bags, report_type: report_type, farmer: farmer)
  end


  def save_black_eyed_beans_planting(black_eyed_beans_planting, farmer)
    kg_planted = black_eyed_beans_planting[0]
    return if kg_planted.nil?
    BlackEyedBeansReport.create(kg_of_seed_planted: kg_planted, farmer: farmer, report_type: 'planting')
  end


  def save_black_eyed_beans_harvest(black_eyed_beans_harvest, farmer)
    bags_harvested = black_eyed_beans_harvest[0]
    grade_1_bags = black_eyed_beans_harvest[1]
    grade_2_bags = black_eyed_beans_harvest[2]
    ungraded_bags = black_eyed_beans_harvest[3]
    report_type = 'harvest'
    return if bags_harvested.nil?
    BlackEyedBeansReport.create(bags_harvested: bags_harvested, grade_1_bags: grade_1_bags, grade_2_bags: grade_2_bags, ungraded_bags: ungraded_bags, report_type: report_type, farmer: farmer)
  end


end