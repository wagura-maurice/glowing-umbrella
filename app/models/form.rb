module Form
  extend self

  #####################################
  ### Response Generation Functions ###
  #####################################

  def respond_to_form
    # Validates response, if valid stores it, else returns error message
    # Special cases where we don't expect responses:
    # If its the first question or last question
    if has_response?
      @response_valid = validate_response
      if @response_valid
        store_response
        move_to_next_question
        ret = get_text(@current_form, @current_question)
      else
        ret = get_error_message(@current_form, @current_question)
        return ret
      end
    else
      ret = get_text(@current_form, @current_question)
    end
#    # If the response is valid, store it, increment question number
#    # and return the text for the next question
#    if @response_valid
#      @next_question = get_next_question
    #
#    # If the response is not valid, return an error message
#    else
      #
#    end
#
#    return ret
  end


  def get_next_question
#    debugger
#    if is_last_question?
#      return nil
#    end
    next_question = get_form(@current_form)[:questions][@current_question][:next_question]
#    if (next_question.is_a? Hash) and (has_response?)
#      return next_question[@response]
#    else
#      return next_question
#    end
    return next_question
  end



  #####################################
  ### Response Management Functions ###
  #####################################

  # Validates the current response
  def validate_response
    return false if !@response.present?
    valid_responses = get_valid_responses(@current_form, @current_question)
    if valid_responses == :any
      return true
    elsif valid_responses == :any_number
      return @response.scan(/[a-zA-Z]/).length == 0
    elsif valid_responses == :any_letters
      return @response[/[a-zA-Z\s]+/] == @response
    elsif valid_responses == :unique_id_number
      return !(Farmer.where(national_id_number: @response).exists?)
    elsif valid_responses.is_a? Array
      return valid_responses.include? @response
    elsif valid_responses.is_a? Symbol
      return self.send(valid_responses)
    else
      return false
    end
    return false
  end


  # Saves the response to the current session
  def store_response
    save_key = get_save_key(@current_form, @current_question)
    @session[save_key] = @response
  end


  def has_response?
    if !@has_response.nil?
      return @has_response
    end
    return false if is_last_question? and !wait_for_response?
    return true if has_ussd_response?
    return false
  end

  def move_to_next_question
    if wait_for_response?
      return go_to_next_form self.send @form[:questions][@current_question][:next_form]
    end
    if @next_question.is_a? Hash
      @current_question = @next_question[@response]
    else
      @current_question = @next_question
    end
    @next_question = get_next_question
  end

  ############################
  ### Form Query Functions ###
  ############################
  
  # Returns a form
  def get_form(form_name)
    form = self.send(form_name)
    return form
  end


  # Returns whether the current question is the 
  # last question for the current form
  def is_last_question?
    return false if @current_question.is_a? Hash
    question = get_question(@current_form, @current_question)
    return question[:next_question].nil?
  end


  def is_first_question?
    @current_question == start_id
  end


  # Gets the start id of the current form
  def start_id
    @form[:start_id]
  end


  def wait_for_response?
    question = @form[:questions][@current_question]
    if question.has_key? :wait_until_response
      @session[:waiting_for_response] = true
      return question[:wait_until_response]
    else
      return false
    end

  end

  # Returns the question from a given form and question id
  def get_question(form_name, id)
    get_form(form_name)[:questions][id]
  end


  # Gets the id of the first question for a given form
  def get_form_start_id(form_name)
    get_form(form_name)[:start_id]
  end


  # Gets the save key for a given form and question id
  def get_save_key(form_name, question_id)
    get_form(form_name)[:questions][question_id][:save_key]
  end

  
  # Gets the question text for a given form and question id
  def get_text(form_name, question_id)
    text = get_form(form_name)[:questions][question_id][:question_text]
    if text.is_a? Symbol
      self.send text
    else
      return text
    end
  end


  # Gets the error message for a given form and question id
  def get_error_message(form_name, question_id)
    get_form(form_name)[:questions][question_id][:error_message]
  end


  # Gets the valid responses for a given form and question id
  def get_valid_responses(form_name, question_id)
    get_form(form_name)[:questions][question_id][:valid_responses]
  end


  # Returns the form name for a given crop
  def get_crop_form_name(crop)
    form_name = (crop.to_s + "_report").to_sym
  end


  #############
  ### Forms ###
  #############

  def user_registration
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "Welcome to eGranary service. T&C's Apply \nAre you posting as an individual or a group? \n1. Individual \n2. Group",
          valid_responses: ["1", "2"],
          next_question: {"1" => 2, "2" => 4},
          conditional_response: true,
          save_key: :reporting_as,
          error_message: "You're response was not understood. Please respond with: \n1. Individual \n2. Group"
        },
        2 => {
          question_text: "Please enter your FULL NAME",
          valid_responses: :any_letters,
          save_key: :name,
          next_question: 3,
          error_message: "Please use alphabetical letters only e.g Tim Mwangi. Please enter FULL NAME"
        },
        3 => {
          question_text: "Please enter ID NUMBER",
          valid_responses: :unique_id_number,
          store_validator_function: true,
          save_key: :national_id_number,
          next_question: 6,
          error_message: "The ID Number is not valid or it is already registered. Please enter a new ID NUMBER"
        },
        4 => {
          question_text: "Please enter Group Name",
          valid_responses: :any,
          save_key: :group_name,
          next_question: 5,
          error_message: "You're response was not understood. Please enter Group Name"
        },
        5 => {
          question_text: "Please enter REGISTRATION NUMBER",
          valid_responses: :any,
          save_key: :group_registration_number,
          next_question: 6,
          error_message: "The ID Number is not valid or it is already registered. Please enter a new ID NUMBER" #"You're response was not understood. Please enter REGISTRATION NUMBER"
        },
        6 => {
          question_text: "Please name any National Farmers Association/Federation/Cooperative you are affiliated with",
          valid_responses: :any,
          save_key: :association,
          next_question: 7,
          error_message: "You're response was not understood. Please name any National Farmers Association/Federation/Cooperative you are affiliated with"
        },
        7 => {
          question_text: "What is your nearest major town?",
          valid_responses: :any_letters,
          save_key: :nearest_town,
          next_question: 8,
          error_message: "Sorry, that answer was not valid. What is your nearest major town?"
        },
        8 => {
          question_text: "What county are you in?",
          valid_responses: :any_letters,
          save_key: :county,
          next_question: 9,
          error_message: "Sorry, that answer was not valid. What county are you in?"
        },
        9 => {
          question_text: "Thank you for registering!",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        }
      },
      model: Farmer,
      form_last_action: :new_farmer
    }
  end


  def update_farmer_crop_report_values
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "Do you grow maize? \n1. Yes\n2. No\n",
          valid_responses: ["1", "2"],
          save_key: :grows_maize,
          next_question: 2,
          error_message: "Sorry, that answer was not valid. Do you grow maize? \n1. Yes\n2. No\n"
        },
        2 => {
          question_text: "Do you grow rice? \n1. Yes\n2. No\n",
          valid_responses: ["1", "2"],
          save_key: :grows_rice,
          next_question: 3,
          error_message: "Sorry, that answer was not valid. Do you grow rice? \n1. Yes\n2. No\n"
        },
        3 => {
          question_text: "Thank you for updating your information!",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        }
      },
      model: Farmer,
      form_last_action: :update_farmer_crop_report_values
    }
  end


  def home_menu
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: :get_home_menu_welcome_message,
          valid_responses: ["1", "2"],
          save_key: :plant_or_harvest,
          next_question: {"1" => 2, "2" => 4},
          error_message: "Sorry, that answer was not valid. What do you want to do? \n1. Report Planting\n2. Report Harvest\n"
        },
        2 => {
          question_text: "What did you plant? \n1. Maize\n2. Rice\n3. Beans\n4. Green Grams (Ndengu)\n5. Black Eyed Beans (Njahi)",
          valid_responses: ["1", "2", "3", "4", "5"],
          save_key: :crop_planted,
          next_question: 3,
          error_message: "Sorry, that answer was not valid. What did you plant? \n1. Maize\n2. Rice\n3. Beans\n4. Green Grams (Ndengu)\n5. Black Eyed Beans (Njahi)"
        },
        3 => {
          question_text: :get_planting_question_text,
          valid_responses: :any_number,
          save_key: :kg_planted,
          next_question: nil,
          wait_until_response: true,
          next_form: :save_planting_report,
          error_message: "You're response was not valid. How many kilograms of did you plant?"
        },
        4 => {
          question_text: "What did you harvest? \n1. Maize\n2. Rice\n3. Beans\n4. Green Grams (Ndengu)\n5. Black Eyed Beans (Njahi)",
          valid_responses: ["1", "2", "3", "4", "5"],
          save_key: :crop_harvested,
          next_question: nil,
          wait_until_response: true,
          next_form: :get_report_harvesting_form,
          error_message: "Sorry, that answer was not valid. What did you harvest? \n1. Maize\n2. Rice\n3. Beans\n4. Green Grams (Ndengu)\n5. Black Eyed Beans (Njahi)"
        }
      },
      model: Farmer,
      form_last_action: :report_planting_or_harvesting
    }
  end

  def get_home_menu_welcome_message
    if @forms_filled.length > 0
      "Would you like to? \n1. Report Planting\n2. Report Harvest\n"
    else
      "Welcome to eGranary service T&C's apply. What do you want to do? \n1. Report Planting\n2. Report Harvest\n"
    end
  end

  def get_planting_question_text
    case @session[:crop_planted]
    when "1"
      crop = "maize"
    when "2"
      crop = "rice"
    when "3"
      crop = "beans"
    when "4"
      crop = "green grams (ndengu)"
    when "5"
      crop = "black eyed beans (njahi)"
    end
    return "How many kilograms of #{crop} did you plant?"
  end


  def get_report_harvesting_form
    case @response
    when "1"
      return :maize_report
    when "2"
      return :rice_report
    when "3"
      return :beans_report
    when "4"
      return :green_grams_report
    when "5"
      return :black_eyed_beans_report
    end
  end

  def save_planting_report
    return @form[:model].send @form[:form_last_action], @session
  end

  def maize_report
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "How many bags of maize harvested?",
          valid_responses: :any_number,
          save_key: :bags_harvested,
          next_question: 2,
          error_message: "You're response was not valid. How many bags of rice harvested?"
        },
        2 => {
          question_text: "How many bags are Grade 1?",
          valid_responses: :less_than_bags_harvested,
          save_key: :grade_1_bags,
          next_question: 3,
          error_message: "You're response was not valid. How many bags are Grade 1?"
        },
        3 => {
          question_text: "How many bags are Grade 2?",
          valid_responses: :less_than_bags_harvested_minus_grade_1,
          save_key: :grade_2_bags,
          next_question: 4,
          error_message: "You're response was not valid. How many bags are Grade 2?"
        },
        4 => {
          question_text: "How many bags are ungraded?",
          valid_responses: :less_than_bags_harvested_minus_grade_1_and_2,
          save_key: :ungraded_bags,
          next_question: 5,
          error_message: "You're response was not valid. How many bags are ungraded?"
        },
        5 => {
          question_text: "Thank you for reporting on on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        }
      },
      model: MaizeReport,
      form_last_action: :new_report
    }
  end


  def rice_report
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "How many bags of rice harvested (Paddy)?",
          valid_responses: :any_number,
          save_key: :bags_harvested,
          next_question: 2,
          error_message: "You're response was not valid. How many bags harvested of rice (Paddy)?"
        },
        2 => {
          question_text: "How many bags are Pishori?",
          valid_responses: :less_than_bags_harvested,
          save_key: :pishori_bags,
          next_question: 3,
          error_message: "You're response was not valid. How many bags are Pishori?"
        },
        3 => {
          question_text: "How many bags are Super?",
          valid_responses: :less_than_bags_harvested_and_pishori,
          save_key: :super_bags,
          next_question: 4,
          error_message: "You're response was not valid. How many bags are Super?"
        },
        4 => {
          question_text: "How many bags are Other?",
          valid_responses: :less_than_bags_harvested_and_pishori_and_super,
          save_key: :other_bags,
          next_question: 5,
          error_message: "You're response was not valid. How many bags are Other?"
        },
        5 => {
          question_text: "Thank you for reporting on on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        }
      },
      model: RiceReport,
      form_last_action: :new_report
    }
  end

  def beans_report
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "How many bags of beans harvested?",
          valid_responses: :any_number,
          save_key: :bags_harvested,
          next_question: 2,
          error_message: "You're response was not valid. How many bags of beans harvested?"
        },
        2 => {
          question_text: "How many bags are Grade 1?",
          valid_responses: :less_than_bags_harvested,
          save_key: :grade_1_bags,
          next_question: 3,
          error_message: "You're response was not valid. How many bags are Grade 1?"
        },
        3 => {
          question_text: "How many bags are Grade 2?",
          valid_responses: :less_than_bags_harvested_minus_grade_1,
          save_key: :grade_2_bags,
          next_question: 4,
          error_message: "You're response was not valid. How many bags are Grade 2?"
        },
        4 => {
          question_text: "How many bags are ungraded?",
          valid_responses: :less_than_bags_harvested_minus_grade_1_and_2,
          save_key: :ungraded_bags,
          next_question: 5,
          error_message: "You're response was not valid. How many bags are ungraded?"
        },
        5 => {
          question_text: "Thank you for reporting on on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        }
      },
      model: BeansReport,
      form_last_action: :new_report
    }
  end

  def green_grams_report
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "How many bags of green grams (ndengu) harvested?",
          valid_responses: :any_number,
          save_key: :bags_harvested,
          next_question: 2,
          error_message: "You're response was not valid. How many bags of green grams (ndengu) harvested?"
        },
        2 => {
          question_text: "How many bags are Grade 1?",
          valid_responses: :less_than_bags_harvested,
          save_key: :grade_1_bags,
          next_question: 3,
          error_message: "You're response was not valid. How many bags are Grade 1?"
        },
        3 => {
          question_text: "How many bags are Grade 2?",
          valid_responses: :less_than_bags_harvested_minus_grade_1,
          save_key: :grade_2_bags,
          next_question: 4,
          error_message: "You're response was not valid. How many bags are Grade 2?"
        },
        4 => {
          question_text: "How many bags are ungraded?",
          valid_responses: :less_than_bags_harvested_minus_grade_1_and_2,
          save_key: :ungraded_bags,
          next_question: 5,
          error_message: "You're response was not valid. How many bags are ungraded?"
        },
        5 => {
          question_text: "Thank you for reporting on on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        }
      },
      model: GreenGramsReport,
      form_last_action: :new_report
    }
  end

  def black_eyed_beans_report
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "How many bags of black eyed beans (njahi) harvested?",
          valid_responses: :any_number,
          save_key: :bags_harvested,
          next_question: 2,
          error_message: "You're response was not valid. How many bags of black eyed beans (njahi) harvested?"
        },
        2 => {
          question_text: "How many bags are Grade 1?",
          valid_responses: :less_than_bags_harvested,
          save_key: :grade_1_bags,
          next_question: 3,
          error_message: "You're response was not valid. How many bags are Grade 1?"
        },
        3 => {
          question_text: "How many bags are Grade 2?",
          valid_responses: :less_than_bags_harvested_minus_grade_1,
          save_key: :grade_2_bags,
          next_question: 4,
          error_message: "You're response was not valid. How many bags are Grade 2?"
        },
        4 => {
          question_text: "How many bags are ungraded?",
          valid_responses: :less_than_bags_harvested_minus_grade_1_and_2,
          save_key: :ungraded_bags,
          next_question: 5,
          error_message: "You're response was not valid. How many bags are ungraded?"
        },
        5 => {
          question_text: "Thank you for reporting on on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        }
      },
      model: BlackEyedBeansReport,
      form_last_action: :new_report
    }
  end

  ####################################
  ### Validation Utility Functions ###
  ####################################

  # The following functions validate the nunber of bags for a given crop
  def less_than_bags_harvested
    @response = @response.to_f
    bags_harvested = @session[:bags_harvested].to_f
    return @response <= bags_harvested
  end


  def less_than_bags_harvested_minus_grade_1
    @response = @response.to_f
    bags_harvested = @session[:bags_harvested].to_f
    grade_1_bags = @session[:grade_1_bags].to_f
    return @response <= bags_harvested - grade_1_bags
  end


  def less_than_bags_harvested_minus_grade_1_and_2
    @response = @response.to_f
    bags_harvested = @session[:bags_harvested].to_f
    grade_1_bags = @session[:grade_1_bags].to_f
    grade_2_bags = @session[:grade_2_bags].to_f
    return @response <= bags_harvested - grade_1_bags - grade_2_bags
  end


  def less_than_bags_harvested_and_pishori
    @response = @response.to_f
    bags_harvested = @session[:bags_harvested].to_f
    pishori_bags = @session[:pishori_bags].to_f
    return @response <= bags_harvested - pishori_bags
  end


  def less_than_bags_harvested_and_pishori_and_super
    @response = @response.to_f
    bags_harvested = @session[:bags_harvested].to_f
    pishori_bags = @session[:pishori_bags].to_f
    super_bags = @session[:super_bags].to_f
    return @response <= bags_harvested - pishori_bags - super_bags
  end


  # Validate county
  def self.valid_county
    @response = @response.downcase
    return kenyan_counties.has_key? @response
  end


  # Valid county keys
  def kenyan_counties
    counties = {"mombasa" => "Mombasa",
                "kwale" => "Kwale",
                "kilifi" => "Kilifi",
                "tana river" => "Tana River",
                "tana" => "Tana River",
                "lamu" => "Lamu",
                "taita-taveta" => "Taita-Taveta",
                "taita taveta" => "Taita-Taveta",
                "taita" => "Taita-Taveta",
                "taveta" => "Taita-Taveta",
                "garissa" => "Garissa",
                "wajir" => "Wajir",
                "mandera" => "Mandera",
                "marsabit" => "Marsabit",
                "isiolo" => "Isiolo",
                "meru" => "Meru",
                "tharaka-nithi" => "Tharaka-Nithi",
                "tharaka nithi" => "Tharaka-Nithi",
                "tharaka" => "Tharaka-Nithi",
                "nithi" => "Tharaka-Nithi",
                "embu" => "Embu",
                "kitui" => "Kitui",
                "machakos" => "Machakos",
                "makueni" => "Makueni",
                "nyandarua" => "Nyandarua",
                "nyeri" => "Nyeri",
                "kirinyaga" => "Kirinyaga",
                "murang'a" => "Muranga",
                "muranga" => "Muranga",
                "kiambu" => "Kiambu",
                "turkana" => "Turkana",
                "west pokot" => "West Pokot",
                "pokot" => "West Pokot",
                "samburu" => "Samburu",
                "trans nzoia" => "Trans Nzoia",
                "transnzoia" => "Trans Nzoia",
                "nzoia" => "Trans Nzoia",
                "trans" => "Trans Nzoia",
                "uasin gishu" => "Uasin Gishu",
                "gishu" => "Uasin Gishu",
                "uasin" => "Uasin Gishu",
                "elgeyo-marakwet" => "Elgeyo-Marakwet",
                "elgeyo marakwet" => "Elgeyo-Marakwet",
                "elgeyo" => "Elgeyo-Marakwet",
                "marakwet" => "Elgeyo-Marakwet",
                "nandi" => "Nandi",
                "baringo" => "Baringo",
                "laikipia" => "Laikipia",
                "nakuru" => "Nakuru",
                "narok" => "Narok",
                "kajiado" => "Kajiado",
                "kericho" => "Kericho",
                "bomet" => "Bomet",
                "kakamega" => "Kakamega",
                "vihiga" => "Vihiga",
                "bungoma" => "Bungoma",
                "busia" => "Busia",
                "siaya" => "Siaya",
                "kisumu" => "Kisumu",
                "homa bay" => "Homa Bay",
                "migori" => "Migori",
                "kisii" => "Kisii",
                "nyamira" => "Nyamira",
                "nairobi" => "Nairobi"}
    return counties
  end


end
