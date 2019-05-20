module PlantingInputsForms

  def maize_report
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "How many bags of 50KG C.A.N top dressing fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_can_fertilizer,
          next_question: 2,
          error_message: "You're response was not valid. How many bags of 50KG C.A.N top dressing fertilizer do you want?"
        },
        2 => {
          question_text: "Request for other crops you planted? \n1. Yes \n2. No",
          valid_responses: ["1", "2"],
          save_key: :other_crops_harvested,
          before_next_question_callback: :save_input_data,
          next_question: {"1" => 4, "2" => 3},
          error_message: "You're response was not valid. Request for other crops you planted? \n1. Yes \n2. No"
        },
        3 => {
          question_text: "Thank you for requesting inputs on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        },
        4 => {
          question_text: :get_inputs_menu_text,
          valid_responses: :get_inputs_menu_valid_responses,
          save_key: :planting_inputs,
          next_question: nil,
          wait_until_response: true,
          next_form: :get_report_inputs_form,
          error_message: :get_inputs_menu_error_message
        }
      },
      model: MaizeReport,
      form_last_action: :input_report
    }
  end


  def rice_report
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "How many bags of 50KG C.A.N top dressing fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_can_fertilizer,
          next_question: 2,
          error_message: "You're response was not valid. How many bags of 50KG C.A.N top dressing fertilizer do you want?"
        },
        2 => {
          question_text: "Request for other crops you planted? \n1. Yes \n2. No",
          valid_responses: ["1", "2"],
          save_key: :other_crops_harvested,
          before_next_question_callback: :save_input_data,
          next_question: {"1" => 4, "2" => 3},
          error_message: "You're response was not valid. Request for other crops you planted? \n1. Yes \n2. No"
        },
        3 => {
          question_text: "Thank you for requesting inputs on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        },
        4 => {
          question_text: :get_inputs_menu_text,
          valid_responses: :get_inputs_menu_valid_responses,
          save_key: :planting_inputs,
          next_question: nil,
          wait_until_response: true,
          next_form: :get_report_inputs_form,
          error_message: :get_inputs_menu_error_message
        }
      },
      model: RiceReport,
      form_last_action: :input_report
    }
  end

  def nerica_rice_report
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "How many bags of 50KG C.A.N top dressing fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_can_fertilizer,
          next_question: 2,
          error_message: "You're response was not valid. How many bags of 50KG C.A.N top dressing fertilizer do you want?"
        },
        2 => {
          question_text: "Request for other crops you planted? \n1. Yes \n2. No",
          valid_responses: ["1", "2"],
          save_key: :other_crops_harvested,
          before_next_question_callback: :save_input_data,
          next_question: {"1" => 4, "2" => 3},
          error_message: "You're response was not valid. Request for other crops you planted? \n1. Yes \n2. No"
        },
        3 => {
          question_text: "Thank you for requesting inputs on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        },
        4 => {
          question_text: :get_inputs_menu_text,
          valid_responses: :get_inputs_menu_valid_responses,
          save_key: :planting_inputs,
          next_question: nil,
          wait_until_response: true,
          next_form: :get_report_inputs_form,
          error_message: :get_inputs_menu_error_message
        }
      },
      model: NericaRiceReport,
      form_last_action: :input_report
    }
  end

  def beans_report
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "How many bags of 50KG C.A.N top dressing fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_can_fertilizer,
          next_question: 2,
          error_message: "You're response was not valid. How many bags of 50KG C.A.N top dressing fertilizer do you want?"
        },
        2 => {
          question_text: "Request for other crops you planted? \n1. Yes \n2. No",
          valid_responses: ["1", "2"],
          save_key: :other_crops_harvested,
          before_next_question_callback: :save_input_data,
          next_question: {"1" => 4, "2" => 3},
          error_message: "You're response was not valid. Request for other crops you planted? \n1. Yes \n2. No"
        },
        3 => {
          question_text: "Thank you for requesting inputs on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        },
        4 => {
          question_text: :get_inputs_menu_text,
          valid_responses: :get_inputs_menu_valid_responses,
          save_key: :planting_inputs,
          next_question: nil,
          wait_until_response: true,
          next_form: :get_report_inputs_form,
          error_message: :get_inputs_menu_error_message
        }
      },
      model: BeansReport,
      form_last_action: :input_report
    }
  end

  def green_grams_report
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "How many bags of 50KG C.A.N top dressing fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_can_fertilizer,
          next_question: 2,
          error_message: "You're response was not valid. How many bags of 50KG C.A.N top dressing fertilizer do you want?"
        },
        2 => {
          question_text: "Request for other crops you planted? \n1. Yes \n2. No",
          valid_responses: ["1", "2"],
          save_key: :other_crops_harvested,
          before_next_question_callback: :save_input_data,
          next_question: {"1" => 4, "2" => 3},
          error_message: "You're response was not valid. Request for other crops you planted? \n1. Yes \n2. No"
        },
        3 => {
          question_text: "Thank you for requesting inputs on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        },
        4 => {
          question_text: :get_inputs_menu_text,
          valid_responses: :get_inputs_menu_valid_responses,
          save_key: :planting_inputs,
          next_question: nil,
          wait_until_response: true,
          next_form: :get_report_inputs_form,
          error_message: :get_inputs_menu_error_message
        }
      },
      model: GreenGramsReport,
      form_last_action: :input_report
    }
  end

  def black_eyed_beans_report
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "How many bags of 50KG C.A.N top dressing fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_can_fertilizer,
          next_question: 2,
          error_message: "You're response was not valid. How many bags of 50KG C.A.N top dressing fertilizer do you want?"
        },
        2 => {
          question_text: "Request for other crops you planted? \n1. Yes \n2. No",
          valid_responses: ["1", "2"],
          save_key: :other_crops_harvested,
          before_next_question_callback: :save_input_data,
          next_question: {"1" => 4, "2" => 3},
          error_message: "You're response was not valid. Request for other crops you planted? \n1. Yes \n2. No"
        },
        3 => {
          question_text: "Thank you for requesting inputs on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        },
        4 => {
          question_text: :get_inputs_menu_text,
          valid_responses: :get_inputs_menu_valid_responses,
          save_key: :planting_inputs,
          next_question: nil,
          wait_until_response: true,
          next_form: :get_report_inputs_form,
          error_message: :get_inputs_menu_error_message
        }
      },
      model: BlackEyedBeansReport,
      form_last_action: :input_report
    }
  end

  def soya_beans_report
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "How many bags of 50KG C.A.N top dressing fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_can_fertilizer,
          next_question: 2,
          error_message: "You're response was not valid. How many bags of 50KG C.A.N top dressing fertilizer do you want?"
        },
        2 => {
          question_text: "Request for other crops you planted? \n1. Yes \n2. No",
          valid_responses: ["1", "2"],
          save_key: :other_crops_harvested,
          before_next_question_callback: :save_input_data,
          next_question: {"1" => 4, "2" => 3},
          error_message: "You're response was not valid. Request for other crops you planted? \n1. Yes \n2. No"
        },
        3 => {
          question_text: "Thank you for requesting inputs on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        },
        4 => {
          question_text: :get_inputs_menu_text,
          valid_responses: :get_inputs_menu_valid_responses,
          save_key: :planting_inputs,
          next_question: nil,
          wait_until_response: true,
          next_form: :get_report_inputs_form,
          error_message: :get_inputs_menu_error_message
        }
      },
      model: SoyaBeansReport,
      form_last_action: :input_report
    }
  end

  def pigeon_peas_report
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "How many bags of 50KG C.A.N top dressing fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_can_fertilizer,
          next_question: 2,
          error_message: "You're response was not valid. How many bags of 50KG C.A.N top dressing fertilizer do you want?"
        },
        2 => {
          question_text: "Request for other crops you planted? \n1. Yes \n2. No",
          valid_responses: ["1", "2"],
          save_key: :other_crops_harvested,
          before_next_question_callback: :save_input_data,
          next_question: {"1" => 4, "2" => 3},
          error_message: "You're response was not valid. Request for other crops you planted? \n1. Yes \n2. No"
        },
        3 => {
          question_text: "Thank you for requesting inputs on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        },
        4 => {
          question_text: :get_inputs_menu_text,
          valid_responses: :get_inputs_menu_valid_responses,
          save_key: :planting_inputs,
          next_question: nil,
          wait_until_response: true,
          next_form: :get_report_inputs_form,
          error_message: :get_inputs_menu_error_message
        }
      },
      model: PigeonPeasReport,
      form_last_action: :input_report
    }
  end

  def get_inputs_menu_text
    farmer = get_farmer
    two_months_ago = Time.now - 60 * 60 * 24 * 60

    ret = "want did you plant this season? "
    can_report = {}

    # Want to show all crops that we have a planting report for but not a harvest report in the last 2 months
    i = 1
    CROPS.each do |crop_name, data|
      crop_report = data[:model]
        ret += "\n#{i}. #{data[:text]}"
        can_report[i] = crop_name
        i += 1
    end

    can_report[i] = :home_menu
    add_to_session(:inputs_reports_available, can_report)
    ret += "\n#{i}. Return to main menu"
    return ret

  end

  def get_inputs_menu_valid_responses
    return :any if @session[:inputs_reports_available].nil?
    return :any if @session[:inputs_reports_available].length == 0
    ret = []
    @session[:inputs_reports_available].each do |k, v|
      ret << k.to_s
    end
    return ret
  end

  def get_inputs_menu_error_message
    ret = "Sorry, that answer was not valid. "
    ret += get_inputs_menu_text
    return ret
  end

  def get_report_inputs_form
    if !@session[:inputs_reports_available].nil? and @session[:inputs_reports_available].length == 0
      return :home_menu
    end
    crop = @session[:inputs_reports_available][@response.to_i]
    if crop == :home_menu
      @session.delete :plant_or_harvest
      @session.delete :planting_inputs
      return :home_menu
    end
    crop_report = (crop.to_s + "_report").to_sym
    return crop_report
  end

  def save_input_data
    model = get_form_model(@current_form)
    save_action = get_form_last_action(@current_form)
    model.send save_action, @session
    @session[:dont_perform_input_report_in_request] = true
  end

end