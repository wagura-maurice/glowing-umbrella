module Form
  extend self

  #####################################
  ### Response Generation Functions ###
  #####################################

  def respond_to_form(session_id, response=nil)

    # Special cases where we don't expect responses:
    # If its the first question or last question
    if (@question_id == start_id) || (is_last_question?)
      @response_valid = true
    end



    # if its the first question, don't look for a response
    if question_id == start_id(session)
      response = get_text(session, question_id)
      increment_question_id(session, form, question_id)
      return response
    
    # else if its the last question, don't look for a response
    elsif is_last_question?(session)
      response_valid = validate_response(form, session, response, question_id-1)

      # if the response is valid, move to the next question
      if response_valid
        store_response(session, form, question_id-1, response, false)

        return get_text(session, question_id)
      
      # else show an error message
      else
        return get_error_message(form, question_id-1)
      end
      
    # otherwise, look for a response, validate it
    else
      response_valid = validate_response(form, session, response, question_id-1)

      # if the response is valid, move to the next question
      if response_valid
        session = store_response(session, form, question_id-1, response, true)
        increment_question_id(session, form, question_id)
        return get_text(session, question_id)
      
      # else show an error message
      else
        return get_error_message(form, question_id-1)
      end
    end
  end


  def get_next_question(form, question_id)
    next_question = form[:questions][question_id][:next_question]
    if next_question.is_a? Hash
      return next_question
    else
      return next_question
    end
  end



  #####################################
  ### Response Management Functions ###
  #####################################

  # Validates the current response
  def validate_response
    return false if !@current_response.present?
    valid_responses = get_valid_responses(@current_form, @question_id)
    if valid_responses == :any
      return true
    elsif valid_responses == :any_number
      return response.scan(/[a-zA-Z]/).length == 0
    elsif valid_responses == :any_letters
      return response[/[a-zA-Z]+/] == response
    elsif valid_responses == :unique_id_number
      return !(Farmer.where(national_id_number: response).exists?)
    elsif valid_responses.is_a? Array
      return valid_responses.include? response
    elsif valid_responses.is_a? Symbol
      return self.send(valid_responses, response, session)
    else
      return false
    end
    return false
  end


  # Saves the response to the current session
  def store_response()
    save_key = get_save_key(@current_form, @question_id)
    @session[save_key] = @response
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
    question = get_question(@current_form, @question_id)
    return question[:next_question].nil?
  end


  # Gets the start id of the current form
  def start_id
    @form[:start_id]
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
    get_form(form_name)[:questions][question_id][:question_text]
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
          next_question: {"1" => 2, "2" => 5},
          conditional_response: true,
          save_key: :reporting_as,
          error_message: "You're response was not understood. Please respond with: \n1. Individual \n2. Group"
        },
        2 => {
          question_text: "Please enter SURNAME",
          valid_responses: :any_letters,
          save_key: :last_name,
          next_question: 3,
          error_message: "Please use alphabetical letters only e.g Mwangi. Please enter SURNAME"
        },
        3 => {
          question_text: "Please enter OTHER NAMES (e.g. James Juma)",
          valid_responses: :any_letters,
          save_key: :first_name,
          next_question: 4,
          error_message: "Please use alphabetical letters only e.g James Juma. Please enter OTHER NAMES"
        },
        4 => {
          question_text: "Please enter ID NUMBER",
          valid_responses: :unique_id_number,
          store_validator_function: true,
          save_key: :national_id_number,
          next_question: 7,
          error_message: "The ID Number is not valid or it is already registered. Please enter a new ID NUMBER"
        },
        5 => {
          question_text: "Please enter Group Name",
          valid_responses: :any,
          save_key: :group_name,
          next_question: 6,
          error_message: "You're response was not understood. Please enter Group Name"
        },
        6 => {
          question_text: "Please enter REGISTRATION NUMBER",
          valid_responses: :any,
          save_key: :group_registration_number,
          next_question: 7,
          error_message: "The ID Number is not valid or it is already registered. Please enter a new ID NUMBER" #"You're response was not understood. Please enter REGISTRATION NUMBER"
        },
        7 => {
          question_text: "Please name any National Association you are affiliated with",
          valid_responses: :any,
          save_key: :association,
          next_question: 8,
          error_message: "You're response was not understood. Please name any National Association you are affiliated with"
        },
        8 => {
          question_text: "Do you grow maize? \n1. Yes\n2. No\n",
          valid_responses: ["1", "2"],
          save_key: :grows_maize,
          next_question: 9,
          error_message: "Sorry, that answer was not valid. Do you grow maize? \n1. Yes\n2. No\n"
        },
        9 => {
          question_text: "Do you grow rice? \n1. Yes\n2. No\n",
          valid_responses: ["1", "2"],
          save_key: :grows_rice,
          next_question: 10,
          error_message: "Sorry, that answer was not valid. Do you grow rice? \n1. Yes\n2. No\n"
        },
        10 => {
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


  def maize_report
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "How many kilograms of maize seed did you plant?",
          valid_responses: :any_number,
          save_key: :kg_of_maize_seed,
          next_question: 2,
          error_message: "You're response was not valid. How many kilograms of maize seed did you plant?"
        },
        2 => {
          question_text: "How many bags harvested?",
          valid_responses: :any_number,
          save_key: :bags_harvested,
          next_question: 3,
          error_message: "You're response was not valid. How many bags harvested?"
        },
        3 => {
          question_text: "How many bags are Grade 1?",
          valid_responses: :less_than_bags_harvested,
          save_key: :grade_1_bags,
          next_question: 4,
          error_message: "You're response was not valid. How many bags are Grade 1?"
        },
        4 => {
          question_text: "How many bags are Grade 2?",
          valid_responses: :less_than_bags_harvested_minus_grade_1,
          save_key: :grade_2_bags,
          next_question: 5,
          error_message: "You're response was not valid. How many bags are Grade 2?"
        },
        5 => {
          question_text: "How many bags are ungraded?",
          valid_responses: :less_than_bags_harvested_minus_grade_1_and_2,
          save_key: :ungraded_bags,
          next_question: 6,
          error_message: "You're response was not valid. How many bags are ungraded?"
        },
        6 => {
          question_text: "Thank you for reporting on on EAFF egranary. EAFF will try & source for market",
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
          question_text: "How many kilograms of rice seed did you plant?",
          valid_responses: :any_number,
          save_key: :kg_of_rice_seed,
          next_question: 2,
          error_message: "You're response was not valid. How many kilograms of rice seed did you plant?"
        },
        2 => {
          question_text: "How many bags harvested (Paddy)?",
          valid_responses: :any_number,
          save_key: :bags_harvested,
          next_question: 3,
          error_message: "You're response was not valid. How many bags harvested (Paddy)?"
        },
        3 => {
          question_text: "How many bags are Pishori?",
          valid_responses: :less_than_bags_harvested,
          save_key: :pishori_bags,
          next_question: 4,
          error_message: "You're response was not valid. How many bags are Pishori?"
        },
        4 => {
          question_text: "How many bags are Super?",
          valid_responses: :less_than_bags_harvested_and_pishori,
          save_key: :super_bags,
          next_question: 5,
          error_message: "You're response was not valid. How many bags are Super?"
        },
        5 => {
          question_text: "How many bags are Other?",
          valid_responses: :less_than_bags_harvested_and_pishori_and_super,
          save_key: :other_bags,
          next_question: 6,
          error_message: "You're response was not valid. How many bags are Other?"
        },
        6 => {
          question_text: "Thank you for reporting on on EAFF egranary. EAFF will try & source for market",
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


  ####################################
  ### Validation Utility Functions ###
  ####################################

  # The following functions validate the nunber of bags for a given crop
  def self.less_than_bags_harvested
    response = response.to_f
    bags_harvested = session[:bags_harvested].to_f
    return response <= bags_harvested
  end


  def less_than_bags_harvested_minus_grade_1
    response = response.to_f
    bags_harvested = session[:bags_harvested].to_f
    grade_1_bags = session[:grade_1_bags].to_f
    return response <= bags_harvested - grade_1_bags
  end


  def less_than_bags_harvested_minus_grade_1_and_2
    response = response.to_f
    bags_harvested = session[:bags_harvested].to_f
    grade_1_bags = session[:grade_1_bags].to_f
    grade_2_bags = session[:grade_2_bags].to_f
    return response <= bags_harvested - grade_1_bags - grade_2_bags
  end


  def less_than_bags_harvested_and_pishori
    response = response.to_f
    bags_harvested = session[:bags_harvested].to_f
    pishori_bags = session[:pishori_bags].to_f
    return response <= bags_harvested - pishori_bags
  end


  def less_than_bags_harvested_and_pishori_and_super
    response = response.to_f
    bags_harvested = session[:bags_harvested].to_f
    pishori_bags = session[:pishori_bags].to_f
    super_bags = session[:super_bags].to_f
    return response <= bags_harvested - pishori_bags - super_bags
  end


  # Validate county
  def self.valid_county
    response = response.downcase
    return kenyan_counties.has_key? response
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
