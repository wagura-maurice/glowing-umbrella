module HomeMenuForm

  def home_menu
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: :get_home_menu_welcome_message,
          valid_responses: ["1", "2", "3", "4"],
          save_key: :plant_or_harvest,
          next_question: {"1" => 2, "2" => 4, "3" => 7, "4" => 5},
          error_message: "Sorry, that answer was not valid. What do you want to do? \n1. Report Planting\n2. Report Harvest\n3. Request a Loan\n4. Exit Session"
        },
        2 => {
          question_text: :get_planting_menu_text,
          valid_responses: :get_planting_menu_valid_responses,
          save_key: :crop_planted,
          next_question: :get_planting_next_question,
          error_message: :get_planting_menu_error_message
        },
        3 => {
          question_text: :get_planting_question_text,
          valid_responses: :any_number,
          save_key: :kg_planted,
          next_question: :save_planting_report,
          error_message: "You're response was not valid. How many kilograms did you plant?"
        },
        4 => {
          question_text: :get_harvesting_menu_text,
          valid_responses: :get_harvesting_menu_valid_responses,
          save_key: :crop_harvested,
          next_question: nil,
          wait_until_response: true,
          next_form: :get_report_harvesting_form,
          error_message: :get_harvesting_menu_error_message
        },
        5 => {
          question_text: "Thank you for reporting on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil,
          post_action: :reset_home_menu_if_no_action
        },
        6 => {
          question_text: "Other crops planted? \n1. Yes \n2. No",
          valid_responses: ["1", "2"],
          save_key: :has_other_crops_planted,
          next_question: {"1" => 2, "2" => 1},
          error_message: "Sorry, that answer was not valid. Other crops planted? \n1. Yes \n2. No"
        },
        7 => {
          wait_until_response: true,
          next_form: :get_next_loan_form,
          start_next_form: true,
          valid_responses: :any
        }
      },
      model: Farmer,
      form_last_action: :report_planting_or_harvesting
    }
  end


  def get_home_menu_welcome_message
    if @forms_filled.length == 0
      prefix = "Welcome to eGranary service T&C's apply."
      suffix = "Would you like to? \n1. Report Planting\n2. Report Harvest\n3. Request a Loan\n4. Exit session"
    else
      prefix = ""
      suffix = "Would you like to? \n1. Report Planting\n2. Report Harvest\n3. Request a Loan\n4. End Session"
    end
    ret = prefix + " " + suffix
  end


  def reset_home_menu_if_no_action
    debugger
    forms_filled = @forms_filled.dup
    forms_filled.delete(:user_registration)
    forms_filled.delete(:home_menu)
    if forms_filled.length == 0
      @current_question = 1
      @next_question = get_form(@current_form)[:questions][1][:next_question]
    end
  end


end