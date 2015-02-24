module Form
  extend self

  def user_registration
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "What is your first name?",
          valid_responses: :any,
          next_question: 2,
          save_key: :first_name,
          error_message: "Please enter your first name"
        },
        2 => {
          question_text: "What is your last name?",
          valid_responses: :any,
          save_key: :last_name,
          next_question: 3,
          error_message: "Please enter your last name"
        },
        3 => {
          question_text: "What is your ID number?",
          valid_responses: :any,
          save_key: :national_id_number,
          next_question: 4,
          error_message: "Please enter your ID number"
        },
        4 => {
          question_text: "Are you part of a farm association or group? \n1. Yes\n2. No\n",
          valid_responses: ["1", "2"],
          save_key: :is_part_of_an_association,
          next_question: 5,
          error_message: "Sorry, that answer was not valid. Are you part of a farm association or group? \n1. Yes \n2. No\n"
        },
#        5 => {
#          question_text: "What is the name of your association or group?"
#          valid_responses: :any,
#          save_key: :association,
#          next_question: 6,
#          error_message: "Please enter a valid association"
#        },
        5 => {
          question_text: "What county are you located in?",
          valid_responses: :valid_county,
          save_key: :county,
          next_question: 6,
          error_message: "Please enter a valid county"
        },
        6 => {
          question_text: "What is the nearest town?",
          valid_responses: :any,
          save_key: :nearest_town,
          next_question: 7,
          error_message: "Please enter a valid town"
        },
        7 => {
          question_text: "Do you grow maize? \n1. Yes\n2. No\n",
          valid_responses: ["1", "2"],
          save_key: :grows_maize,
          next_question: 8,
          error_message: "Sorry, that answer was not valid. Do you grow maize? \n1. Yes\n2. No\n"
        },
        8 => {
          question_text: "Do you grow rice? \n1. Yes\n2. No\n",
          valid_responses: ["1", "2"],
          save_key: :grows_rice,
          next_question: 9,
          error_message: "Sorry, that answer was not valid. Do you grow rice? \n1. Yes\n2. No\n"
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

  def maize_report
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "How many acres of maize did you plant?",
          valid_responses: :any_number,
          next_question: 2,
          save_key: :acres_of_maize,
          error_message: "Please enter a valid number"
        },
        2 => {
          question_text: "How many kilograms of maize seed did you plant?",
          valid_responses: :any_number,
          save_key: :kg_of_maize_seed,
          next_question: 3,
          error_message: "Please enter a valid number"
        },
        3 => {
          question_text: "What type of maize are your storing? \n1. White Maize\n2. Yellow Maize\n3. Both \n",
          valid_responses: ["1", "2", "3"],
          save_key: :type_of_maize,
          next_question: 4,
          error_message: "Sorry, that answer was not valid. What type of maize are your storing? \n1. White Maize\n2. Yellow Maize\n3. Both \n"
        },
        4 => {
          question_text: "What grade is this maize?\n1. Grade 1 \n2. Grade 2\n3. Grade 3\n4. Ungraded\n",
          valid_responses: ["1", "2", "3", "4"],
          save_key: :maize_grade,
          next_question: 5,
          error_message: "Sorry, that answer was not valid. What grade is this maize?\n1. Grade 1 \n2. Grade 2\n3. Grade 3\n4. Ungraded\n"
        },
        5 => {
          question_text: "How many bags do you have available to sell?",
          valid_responses: :any_number,
          save_key: :bags_to_sell,
          next_question:  6,
          error_message: "Please enter a valid number"
        },
        6 => {
          question_text: "How many kilograms of well dried maize are you ready to sell?",
          valid_responses: :any_number,
          save_key: :well_dried_maize_to_sell,
          next_question: 7,
          error_message: "Please enter a valid number"
        },
        7 => {
          question_text: "Thank you for reporting!",
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
          question_text: "How many acres of rice did you plant?",
          valid_responses: :any_number,
          next_question: 2,
          save_key: :acres_of_rice,
          error_message: "Please enter a valid number"
        },
        2 => {
          question_text: "How many kilograms of rice seed did you plant?",
          valid_responses: :any_number,
          save_key: :kg_of_rice_seed,
          next_question: 3,
          error_message: "Please enter a valid number"
        },
        3 => {
          question_text: "How many kilograms of rice are you storing?",
          valid_responses: :any_number,
          save_key: :kg_of_rice_stored,
          next_question: 4,
          error_message: "Please enter a valid number"
        },
        4 => {
          question_text: "What type of rice are your storing? \n1. Paddy Rice\n2. Non-Paddy Rice\n3. Both \n",
          valid_responses: ["1", "2", "3"],
          save_key: :type_of_rice,
          next_question: 5,
          error_message: "Sorry, that answer was not valid. What type of maize are your storing? \n1. White Maize\n2. Yellow Maize\n3. Both \n"
        },
        5 => {
          question_text: "What type of grain is this rice?\n1. Long grain\n2. Short Grain\n3. Broken Grain\n4. Long and Short Grain\n",
          valid_responses: ["1", "2", "3", "4"],
          save_key: :grain_type,
          next_question: 6,
          error_message: "Sorry, that answer was not valid. What type of grain is this rice?\n1. Long grain\n2. Short Grain\n3. Broken Grain\n4. Long and Short Grain\n"
        },
        6 => {
          question_text: "What type of rice is this? \n1. Aromatic\n2. Non-Aromatic\n3. Both\n",
          valid_responses: ["1", "2", "3"],
          save_key: :rice_aroma,
          next_question: 7,
          error_message: "Sorry, that answer was not valid. What type of rice is this? \n1. Aromatic\n2. Non-Aromatic\n3. Both\n"
        },
        7 => {
          question_text: "How many bags do you have available to sell?",
          valid_responses: :any_number,
          save_key: :bags_to_sell,
          next_question:  8,
          error_message: "Please enter a valid number"
        },
        8 => {
          question_text: "How many kilograms of rice are you ready to sell?",
          valid_responses: :any_number,
          save_key: :kg_to_sell,
          next_question: 9,
          error_message: "Please enter a valid number"
        },
        9 => {
          question_text: "Thank you for reporting!",
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

  def respond_to_form(session_id, response=nil)
    session = get_form_session(session_id)
    form = get_form(session)
    question_id = current_question_id(session)

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


  def expensive_response_valid(session_id, response)
    session = get_form_session(session_id)
    form = get_form(session)
    question_id = current_question_id(session)
    return validate_response(form, session, response, question_id-1)
  end

  def get_next_question(form, question_id)
    form[:questions][question_id][:next_question]
  end

  def increment_question_id(session, form, question_id)
    next_question = get_next_question(form, question_id)
    session[:question] = next_question
    store_session(session)
  end

  def store_response(session, form, question_id, response, increment=nil)
    save_key = get_save_key(form, question_id)
    session[save_key] = response
    if increment 
      session[:question] = get_next_question(form, question_id)
    end
    store_session(session)
  end

  def validate_response(form, session, response, question_id)
    return false if !response.present?
    valid_responses = get_valid_responses(form, question_id)
    if valid_responses == :any
      return true
    elsif valid_responses == :any_number
      return response.scan(/[a-zA-Z]/).length == 0
    elsif valid_responses.is_a? Array
      return valid_responses.include? response
    elsif valid_responses.is_a? Symbol
      return self.send(valid_responses, response)
    else
      return false
    end
    return false
  end

  def get_save_key(form, question_id)
    form[:questions][question_id][:save_key]
  end

  def get_valid_responses(form, question_id)
    form[:questions][question_id][:valid_responses]
  end

  def get_error_message(form, question_id)
    form[:questions][question_id][:error_message]
  end

  def get_form_session(session_id)
    Rails.cache.read(session_id)
  end

  def store_session(session)
    session_id = session[:session_id]
    Rails.cache.write(session_id, session)
    return session
  end

  def get_form_name(session)
    session[:current_form]
  end

  def get_form(session)
    form_name = get_form_name(session)
    form = self.send(form_name)
    return form
  end

  def current_question_id(session)
    session[:question]
  end

  def start_id(session)
    form = self.send(get_form_name(session))
    form[:start_id]
  end

  def get_text(session, question_id)
    form = get_form(session)
    return form[:questions][question_id][:question_text]
  end

  def is_last_question?(session)
    question = get_question(get_form_name(session), current_question_id(session))
    return question[:next_question].nil?
  end

  def get_question(form_name, id)
    form = self.send(form_name)
    form[:questions][id]
  end

  def self.valid_county(response)
    response = response.downcase
    return kenyan_counties.has_key? response
  end

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
