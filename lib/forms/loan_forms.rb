module LoanForms

  def get_next_loan_form
    farmer = get_farmer
    if farmer.accepted_loan_tnc
      return :authenticate_before_loans_menu
    else
      return :accept_loan_tnc_form
    end
  end

  def accept_loan_tnc_form
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "Welcome to eGranary Request a Loan\n1. View Terms and Conditions\n2.Accept Terms and Conditions\n3. Exit",
          valid_responses: ["1", "2", "3"],
          save_key: :tnc_view_or_accept,
          next_question: {"1" => 2, "2" => 3, "3" => 7, "4" => 5},
          error_message: "You're response was not valid. Please choose one of the following:\n1. View Terms and Conditions\n2.Accept Terms and Conditions\n3. Exit"
        },
        2 => {
          question_text: "We will send you an SMS with the Terms and Conditions shortly.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil,
          post_action: :send_tnc_sms,
          skip_last_action: true
        },
        3 => {
          question_text: "Set your 5 digit PIN for your eGranary loans account (e.g. \"12345\")",
          valid_responses: :valid_pin,
          save_key: :pin_value,
          next_question: 4,
          error_message: "Sorry, that PIN is invalid. Set your 5 digit PIN for your eGranary loans account (e.g. \"12345\")"
        },
        4 => {
          question_text: "Please confirm your ID number to save your PIN and proceed",
          valid_responses: :authenticate_national_id,
          save_key: :authenticated_national_id,
          next_question: 5,
          error_message: "Sorry, the ID number you entered is incorrect. Please confirm your ID number to save your PIN and proceed",
          next_form: :loans_main_menu
        },
        5 => {
          question_text: "Thanks for setting your pin.\n",
          valid_responses: :nil,
          save_key: :nil,
          next_question: nil,
          error_message: nil,
          next_form: nil
        }
      },
      model: Farmer,
      form_last_action: :save_pin
    }
  end

  def authenticate_before_loans_menu
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "Welcome #{get_farmer.name}\nPlease enter your PIN to continue",
          valid_responses: :authenticate_pin,
          save_key: :pin_value,
          next_question: nil,
          error_message: "Sorry, that PIN is invalid. Please enter your 5 digit PIN for your eGranary loans account (e.g. \"12345\")",
          next_form: :post_authenticate_form,
          wait_until_response: true
        }
      },
      model: nil,
      form_last_action: nil
    }
  end

  def loans_main_menu
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "Kopa Menu\n1. Get Lima Loan\n2. Get Mavuno Loan\n3. Get Inputs Loan\n4. Pay Outstanding Loans",
          valid_responses: ["1", "2", "3", "4"],
          save_key: :kopa_menu_option,
          next_question: {"1" => 2, "2" => 5, "3" => 8, "4" => 11},
          error_message: "Sorry, that option is invalid. Kopa Menu\n1. Get Lima Loan\n2. Get Mavuno Loan\n3. Get Inputs Loan\n4. Pay Outstanding Loans\n5. Loans Main Menu"
        },
        2 => {
          question_text: "How many shillings do you require for your Lima Loan?",
          valid_responses: :any_number,
          save_key: :lima_loan_amount,
          next_question: 3,
          error_message: "Sorry, that option is invalid. How many shillings do you require for your Lima Loan?"
        },
        3 => {
          question_text: "You have requested a Lima Loan of KES #{@session[:lima_loan_amount]}. T&C's apply.\n1. Continue\n2. Cancel",
          valid_responses: ["1", "2"],
          save_key: :lima_loan_confirmation,
          next_question: {"1" => 4, "2" => 1},
          error_message: "Sorry, that option is invalid. You have requested a Lima Loan of KES #{@session[:lima_loan_amount]}. T&C's apply.\n1. Continue\n2. Cancel",
          next_form: :loans_main_menu
        },
        4 => {
          question_text: "Dear #{get_farmer.name}, you have been loaned #{@session[:lima_loan_amount]}, you should recieve this amount shortly via MPESA.",
          valid_responses: nil,
          save_key: :nil,
          next_question: nil,
          error_message: nil,
          post_action: :clear_lima_loan_params
        },
        5 => {
          question_text: "How many shillings do you require for your Mavuno Loan?",
          valid_responses: :any_number,
          save_key: :mavuno_loan_amount,
          next_question: 6,
          error_message: "Sorry, that option is invalid. How many shillings do you require for your Mavuno Loan?"
        },
        6 => {
          question_text: "You have requested a Mavuno Loan of KES #{@session[:mavuno_loan_amount]}. T&C's apply.\n1. Continue\n2. Cancel",
          valid_responses: ["1", "2"],
          save_key: :mavuno_loan_confirmation,
          next_question: {"1" => 7, "2" => 1},
          error_message: "Sorry, that option is invalid. You have requested a Mavuno Loan of KES #{@session[:mavuno_loan_amount]}. T&C's apply.\n1. Continue\n2. Cancel",
          next_form: :loans_main_menu
        },
        7 => {
          question_text: "Dear #{get_farmer.name}, you have been loaned #{@session[:mavuno_loan_amount]}, you should recieve this amount shortly via MPESA.",
          valid_responses: nil,
          save_key: :nil,
          next_question: nil,
          error_message: nil,
          post_action: :clear_mavuna_loan_params
        },
        8 => {
          question_text: "How many shillings do you require for your Input Voucher Loan?",
          valid_responses: :any_number,
          save_key: :input_voucher_loan_amount,
          next_question: 9,
          error_message: "Sorry, that option is invalid. How many shillings do you require for your Input Voucher Loan?"
        },
        9 => {
          question_text: "You have requested an Input Voucher Loan of KES #{@session[:input_voucher_loan_amount]}. T&C's apply.\n1. Continue\n2. Cancel",
          valid_responses: ["1", "2"],
          save_key: :input_voucher_loan_confirmation,
          next_question: {"1" => 10, "2" => 1},
          error_message: "Sorry, that option is invalid. You have requested an Input Voucher Loan of KES #{@session[:input_voucher_loan_amount]}. T&C's apply.\n1. Continue\n2. Cancel",
          next_form: :loans_main_menu
        },
        10 => {
          question_text: "Dear #{get_farmer.name}, you have been loaned with a voucher worth KES #{@session[:input_voucher_loan_amount]}, you should recieve your voucher code shortly via SMS.",
          valid_responses: nil,
          save_key: :nil,
          next_question: nil,
          error_message: nil,
          post_action: :clear_input_voucher_loan_params
        },
        11 => {
          question_text: "Pay Menu\nPay back your loan via the MPESA paybill number 123456\nPlease enter your ID as the a/c number",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        },
      },
      model: Farmer,
      form_last_action: :save_loan
    }
  end


  def send_tnc_sms
    msg = "Please view the eGranary loans terms and conditions at http://bit.ly/2fGOZmp"
    SendMessages.send(@phone_number, 'eGRANARYKe', msg) unless Rails.env.development?
    if Rails.env.development?
      puts msg
    end
  end


  def clear_lima_loan_params
    @session.delete :lima_loan_amount
    @session.delete :lima_loan_confirmation
  end


  def clear_mavuna_loan_params
    @session.delete :mavuno_loan_amount
    @session.delete :mavuno_loan_confirmation
  end


  def clear_input_voucher_loan_params
    @session.delete :input_voucher_loan_amount
    @session.delete :input_voucher_loan_confirmation
  end


  def post_authenticate_form
    return :loans_main_menu
  end

end