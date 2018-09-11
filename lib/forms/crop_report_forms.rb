module CropReportForms

  def maize_report
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "How many bags of maize harvested?",
          valid_responses: :any_number,
          save_key: :bags_harvested,
          next_question: 2,
          error_message: "You're response was not valid. How many bags of maize harvested?"
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
          question_text: "Other crops harvested? \n1. Yes \n2. No",
          valid_responses: ["1", "2"],
          save_key: :other_crops_harvested,
          before_next_question_callback: :save_crop_data,
          next_question: {"1" => 7, "2" => 6},
          error_message: "You're response was not valid. Other crops harvested? \n1. Yes \n2. No"
        },
        6 => {
          question_text: "Thank you for reporting on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        },
        7 => {
          question_text: :get_harvesting_menu_text,
          valid_responses: :get_harvesting_menu_valid_responses,
          save_key: :crop_harvested,
          next_question: nil,
          wait_until_response: true,
          next_form: :get_report_harvesting_form,
          error_message: :get_harvesting_menu_error_message
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
          question_text: "How many bags of rice harvested?",
          valid_responses: :any_number,
          save_key: :bags_harvested,
          next_question: 2,
          error_message: "You're response was not valid. How many bags of rice harvested?"
        },
        2 => {
          question_text: "How many bags are Grade 1?",
          valid_responses: :less_than_bags_harvested,
          save_key: :pishori_bags,
          next_question: 3,
          error_message: "You're response was not valid. How many bags are Grade 1?"
        },
        3 => {
          question_text: "How many bags are Grade 2?",
          valid_responses: :less_than_bags_harvested_and_pishori,
          save_key: :super_bags,
          next_question: 4,
          error_message: "You're response was not valid. How many bags are Grade 2?"
        },
        4 => {
          question_text: "How many bags are Other?",
          valid_responses: :less_than_bags_harvested_and_pishori_and_super,
          save_key: :other_bags,
          next_question: 5,
          error_message: "You're response was not valid. How many bags are Other?"
        },
        5 => {
          question_text: "Other crops harvested? \n1. Yes \n2. No",
          valid_responses: ["1", "2"],
          save_key: :other_crops_harvested,
          before_next_question_callback: :save_crop_data,
          next_question: {"1" => 7, "2" => 6},
          error_message: "You're response was not valid. Other crops harvested? \n1. Yes \n2. No"
        },
        6 => {
          question_text: "Thank you for reporting on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        },
        7 => {
          question_text: :get_harvesting_menu_text,
          valid_responses: :get_harvesting_menu_valid_responses,
          save_key: :crop_harvested,
          next_question: nil,
          wait_until_response: true,
          next_form: :get_report_harvesting_form,
          error_message: :get_harvesting_menu_error_message
        }
      },
      model: RiceReport,
      form_last_action: :new_report
    }
  end

  def nerica_rice_report
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
          question_text: "Other crops harvested? \n1. Yes \n2. No",
          valid_responses: ["1", "2"],
          save_key: :other_crops_harvested,
          before_next_question_callback: :save_crop_data,
          next_question: {"1" => 7, "2" => 6},
          error_message: "You're response was not valid. Other crops harvested? \n1. Yes \n2. No"
        },
        6 => {
          question_text: "Thank you for reporting on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        },
        7 => {
          question_text: :get_harvesting_menu_text,
          valid_responses: :get_harvesting_menu_valid_responses,
          save_key: :crop_harvested,
          next_question: nil,
          wait_until_response: true,
          next_form: :get_report_harvesting_form,
          error_message: :get_harvesting_menu_error_message
        }
      },
      model: NericaRiceReport,
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
          question_text: "Other crops harvested? \n1. Yes \n2. No",
          valid_responses: ["1", "2"],
          save_key: :other_crops_harvested,
          before_next_question_callback: :save_crop_data,
          next_question: {"1" => 7, "2" => 6},
          error_message: "You're response was not valid. Other crops harvested? \n1. Yes \n2. No"
        },
        6 => {
          question_text: "Thank you for reporting on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        },
        7 => {
          question_text: :get_harvesting_menu_text,
          valid_responses: :get_harvesting_menu_valid_responses,
          save_key: :crop_harvested,
          next_question: nil,
          wait_until_response: true,
          next_form: :get_report_harvesting_form,
          error_message: :get_harvesting_menu_error_message
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
          question_text: "Other crops harvested? \n1. Yes \n2. No",
          valid_responses: ["1", "2"],
          save_key: :other_crops_harvested,
          before_next_question_callback: :save_crop_data,
          next_question: {"1" => 7, "2" => 6},
          error_message: "You're response was not valid. Other crops harvested? \n1. Yes \n2. No"
        },
        6 => {
          question_text: "Thank you for reporting on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        },
        7 => {
          question_text: :get_harvesting_menu_text,
          valid_responses: :get_harvesting_menu_valid_responses,
          save_key: :crop_harvested,
          next_question: nil,
          wait_until_response: true,
          next_form: :get_report_harvesting_form,
          error_message: :get_harvesting_menu_error_message
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
          question_text: "Other crops harvested? \n1. Yes \n2. No",
          valid_responses: ["1", "2"],
          save_key: :other_crops_harvested,
          before_next_question_callback: :save_crop_data,
          next_question: {"1" => 7, "2" => 6},
          error_message: "You're response was not valid. Other crops harvested? \n1. Yes \n2. No"
        },
        6 => {
          question_text: "Thank you for reporting on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        },
        7 => {
          question_text: :get_harvesting_menu_text,
          valid_responses: :get_harvesting_menu_valid_responses,
          save_key: :crop_harvested,
          next_question: nil,
          wait_until_response: true,
          next_form: :get_report_harvesting_form,
          error_message: :get_harvesting_menu_error_message
        }
      },
      model: BlackEyedBeansReport,
      form_last_action: :new_report
    }
  end

  def soya_beans_report
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "How many bags of soya beans harvested?",
          valid_responses: :any_number,
          save_key: :bags_harvested,
          next_question: 2,
          error_message: "You're response was not valid. How many bags of soya beans harvested?"
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
          question_text: "Other crops harvested? \n1. Yes \n2. No",
          valid_responses: ["1", "2"],
          save_key: :other_crops_harvested,
          before_next_question_callback: :save_crop_data,
          next_question: {"1" => 7, "2" => 6},
          error_message: "You're response was not valid. Other crops harvested? \n1. Yes \n2. No"
        },
        6 => {
          question_text: "Thank you for reporting on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        },
        7 => {
          question_text: :get_harvesting_menu_text,
          valid_responses: :get_harvesting_menu_valid_responses,
          save_key: :crop_harvested,
          next_question: nil,
          wait_until_response: true,
          next_form: :get_report_harvesting_form,
          error_message: :get_harvesting_menu_error_message
        }
      },
      model: SoyaBeansReport,
      form_last_action: :new_report
    }
  end

  def pigeon_peas_report
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "How many bags of pigeon peas harvested?",
          valid_responses: :any_number,
          save_key: :bags_harvested,
          next_question: 2,
          error_message: "You're response was not valid. How many bags of pigeon peas harvested?"
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
          question_text: "Other crops harvested? \n1. Yes \n2. No",
          valid_responses: ["1", "2"],
          save_key: :other_crops_harvested,
          before_next_question_callback: :save_crop_data,
          next_question: {"1" => 7, "2" => 6},
          error_message: "You're response was not valid. Other crops harvested? \n1. Yes \n2. No"
        },
        6 => {
          question_text: "Thank you for reporting on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        },
        7 => {
          question_text: :get_harvesting_menu_text,
          valid_responses: :get_harvesting_menu_valid_responses,
          save_key: :crop_harvested,
          next_question: nil,
          wait_until_response: true,
          next_form: :get_report_harvesting_form,
          error_message: :get_harvesting_menu_error_message
        }
      },
      model: PigeonPeasReport,
      form_last_action: :new_report
    }
  end

  def get_harvesting_menu_text
    farmer = get_farmer
    two_months_ago = Time.now - 60 * 60 * 24 * 60

    ret = "What did you harvest? "
    can_report = {}

    # Want to show all crops that we have a planting report for but not a harvest report in the last 2 months
    i = 1
    CROPS.each do |crop_name, data|
      crop_report = data[:model]
      last_crop_report = crop_report.where(farmer: farmer).where("created_at >= ? ", two_months_ago).where(report_type: 'planting').where(harvest_report_id: nil).order(created_at: :desc).first
      if last_crop_report.present?
        ret += "\n#{i}. #{data[:text]}"
        can_report[i] = crop_name
        i += 1
      end
    end

    if can_report.length == 0
      add_to_session(:harvesting_reports_available, {})
      return "You have not reported planting any crops. Please report what you planted before reporting your harvest. Enter any number to return to the main menu"
    else
      can_report[i] = :home_menu
      add_to_session(:harvesting_reports_available, can_report)
      ret += "\n#{i}. Return to main menu"
      return ret
    end

  end


  def get_planting_menu_text
    farmer = get_farmer
    two_months_ago = Time.now - 60 * 60 * 24 * 60

    ret = "What did you plant? "
    can_report = {}

    # Want to show all crops that we don't have a planting report for from the last two months that has a harvesting report
    i = 1
    CROPS.each do |crop_name, data|
      crop_report = data[:model]

      last_crop_report = crop_report.where(farmer: farmer).where("created_at >= ? ", two_months_ago).where(report_type: 'planting').where(harvest_report_id: nil).order(created_at: :desc).first
      unless last_crop_report.present?
        ret += "\n#{i}. #{data[:text]}"
        can_report[i] = crop_name
        i += 1
      end
    end

    if can_report.length == 0
      add_to_session(:planting_reports_available, {})
      return "You have reported planting all the different crop types, please report their harvesting now. Enter any number to continue"
    else
      can_report[i] = :home_menu
      add_to_session(:planting_reports_available, can_report)
      ret += "\n#{i}. Return to main menu"
      return ret
    end
  end

  def get_planting_menu_valid_responses
    return :any if @session[:planting_reports_available].nil?
    return :any if @session[:planting_reports_available].length == 0
    ret = []
    @session[:planting_reports_available].each do |k, v|
      ret << k.to_s
    end
    return ret
  end

  def get_harvesting_menu_valid_responses
    return :any if @session[:harvesting_reports_available].nil?
    return :any if @session[:harvesting_reports_available].length == 0
    ret = []
    @session[:harvesting_reports_available].each do |k, v|
      ret << k.to_s
    end
    return ret
  end

  def get_planting_next_question
    if @session[:planting_reports_available].nil? || @session[:planting_reports_available].length == 0
      return 4
    elsif @session[:planting_reports_available][@response.to_i] == :home_menu
      return 1
    end
    return 3
  end

  def get_planting_menu_error_message
    ret = "Sorry, that answer was not valid. "
    ret += get_planting_menu_text
    return ret
  end

  def get_harvesting_menu_error_message
    ret = "Sorry, that answer was not valid. "
    ret += get_harvesting_menu_text
    return ret
  end


  def get_planting_question_text
    resp = @session[:planting_reports_available][@session[:crop_planted].to_i]
    if resp == :home_menu
      @session.delete :plant_or_harvest
      @session.delete :crop_planted
      return get_home_menu_welcome_message
    end
    crop = CROPS[resp][:text]
    return "How many kilograms of #{crop} did you plant?"
  end


  def get_report_harvesting_form
    if !@session[:harvesting_reports_available].nil? and @session[:harvesting_reports_available].length == 0
      return :home_menu
    end
    crop = @session[:harvesting_reports_available][@response.to_i]
    if crop == :home_menu
      @session.delete :plant_or_harvest
      @session.delete :crop_harvested
      return :home_menu
    end
    crop_report = (crop.to_s + "_report").to_sym
    return crop_report
  end

  def save_planting_report
    @forms_filled << :report_planting
    @form[:model].send @form[:form_last_action], @session
    return 6
  end

  def save_crop_data
    model = get_form_model(@current_form)
    save_action = get_form_last_action(@current_form)
    model.send save_action, @session
    @session[:dont_perform_new_report_in_request] = true
  end

end