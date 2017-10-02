module LoanForms

  @@tnc_url = 'http://bit.ly/2fGOZmp'


  def accept_loan_tnc_form
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "Welcome to eGranary Loans Menu - Continue to set up your loan account\n1. View Terms and Conditions\n2. Accept Terms and Conditions\n3. Exit",
          valid_responses: ["1", "2", "3"],
          save_key: :tnc_view_or_accept,
          next_question: {"1" => 2, "2" => 3, "3" => 6},
          error_message: "You're response was not valid. Please choose one of the following:\n1. View Terms and Conditions\n2. Accept Terms and Conditions\n3. Exit"
        },
        2 => {
          question_text: "You can view the eGranary Terms and Conditions here: #{@@tnc_url}\n1.Accept Terms and Conditions\n2. Exit",
          valid_responses: ["1", "2"],
          save_key: :tnc_view_or_accept,
          next_question: {"1" => 3, "2" => 6},
          error_message: "You're response was not valid. Please choose one of the following:\n1.Accept Terms and Conditions\n2. Exit",
          post_action: :send_tnc_sms,
          skip_last_action: true
        },
        3 => {
          question_text: "Set your 4 digit PIN for your eGranary loans account (e.g. \"1234\")",
          valid_responses: :valid_pin,
          save_key: :pin_value,
          next_question: 4,
          error_message: "Sorry, that PIN is invalid. Set your 4 digit PIN for your eGranary loans account (e.g. \"1234\")"
        },
        4 => {
          question_text: "Please confirm your ID number to save your PIN and proceed",
          valid_responses: :authenticate_national_id,
          save_key: :authenticated_national_id,
          next_question: 5,
          error_message: "Sorry, the ID number you entered is incorrect. Please confirm your ID number to save your PIN and proceed",
          next_form: :home_menu
        },
        5 => {
          question_text: "Thanks for setting your pin.",
          valid_responses: :nil,
          save_key: :nil,
          next_question: nil,
          error_message: nil,
          next_form: nil
        },
        6 => {
          question_text: "Thank you for participating in eGranary Loans.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        }
      },
      model: Farmer,
      form_last_action: :save_pin
    }
  end


  # Convenience method called from "start_next_form" question that returns
  # the next form
  def view_loans_form
    if has_authenticated?
      return :view_loans
    else
      return :authenticate_before_loans_menu
    end
  end

  def view_loans
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: :get_view_loans_text,
          valid_responses: :get_view_loans_valid_responses,
          save_key: :loan_to_view,
          next_question: :get_view_loans_next_question,
          error_message: :get_view_loans_error_message
        },
        2 => {
          question_text: :get_individual_loan_text,
          valid_responses: ["1", "2"],
          save_key: :nil,
          next_question: {"1" => 1, "2" => 4},
          error_message: :get_individual_loan_error_message
        },
        3 => {
          next_form: :return_home_menu,
          start_next_form: true
        },
        4 => {
          question_text: "Thank you for participating in eGranary Loans.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil,
          skip_last_action: true
        }
      },
      model: Farmer,
      form_last_action: :nil
    }
  end


  def get_view_loans_text
    loans = get_farmer_loans
    if loans.count == 0
      return "You currently have no loans to view.\n1. Return to main menu\n2. Exit"
    elsif loans.count == 1
      loan = loans.first
      text = get_loan_info_text(loan)
      text += "\n1. Return to main menu\n2. Exit"
    else
      index = 1
      str = "You currently have the following loans. Select one of the following to view:"
      loans.each do |loan|
        str += "\n#{index}. #{loan.currency} #{loan.value} on #{loan.formatted_disbursal_date}"
        index += 1
      end
      str += "\n#{index}. Return to main menu\n#{index + 1}. Exit"
    end
  end


  def get_view_loans_valid_responses
    ret = ["1", "2"]
    loans = get_farmer_loans
    if loans.count > 1
      total_loans = loans.count
      for i in 1..total_loans do
        ret << "#{i + 2}"
      end
    end
    return ret
  end


  def get_view_loans_next_question
    loans = get_farmer_loans
    if loans.count > 1
      ret = {}
      total_loans = loans.count
      for i in 1..total_loans do
        ret["#{i}"] = 2
      end
      ret["#{total_loans + 1}"] = 3
      ret["#{total_loans + 2}"] = 4
      return ret
    else
      return {"1" => 3, "2" => 4}
    end
  end


  def get_view_loans_error_message
    ret = "You're response was not valid. "
    ret += get_view_loans_text
    return ret
  end


  def get_individual_loan_text
    loan_number = @session[:loan_to_view].to_i - 1
    loans = get_farmer_loans
    loan = loans[loan_number]
    ret = get_loan_info_text(loan)
    ret += "\n1. Return to loan menu\n2. Exit"
    return ret
  end

  def get_individual_loan_error_message
    return "You're response was not valid. " + get_individual_loan_text
  end


  def get_loan_info_text(loan)
    str = "You have the current loan outstanding:" +
      "\nLoan Amount: #{loan.currency} #{loan.value}" +
      "\nLoan Duration: #{loan.duration} #{loan.duration_unit}" +
      "\nInterest Rate: #{loan.interest_rate}%" +
      "\nProcessing Fee: #{loan.currency} #{loan.service_charge}" +
      "\nInsurance Fee: #{loan.currency} #{loan.credit_life_fee}"
    return str
  end

  def return_home_menu
    :home_menu
  end

  def send_tnc_sms
    msg = "Please view the eGranary loans terms and conditions here: #{@@tnc_url}"
    SendMessages.send(@phone_number, 'eGRANARYKe', msg) unless Rails.env.development?
    if Rails.env.development?
      puts msg
    end
  end


  ##################################
  ### Loan Authorization Methods ###
  ##################################

  def authenticate_before_loans_menu
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "Welcome #{get_farmer.name}\nPlease enter your PIN to continue",
          valid_responses: :authenticate_pin,
          save_key: :pin_value,
          next_question: nil,
          error_message: "Sorry, that PIN is invalid. Please enter your 4 digit PIN for your eGranary loans account (e.g. \"1234\")",
          next_form: :view_loans_form,
          start_next_form: true,
          wait_until_response: true,
          post_action: :store_authentication
        }
      },
      model: nil,
      form_last_action: nil
    }
  end


  def has_authenticated?
    Rails.cache.read('loan-auth-' + @phone_number) == true
  end


  def store_authentication
    Rails.cache.write('loan-auth-' + @phone_number, true, expires_in: 1.hour)
  end

  # def loans_main_menu
  #   {
  #     start_id: 1,
  #     questions: {
  #       1 => {
  #         question_text: "Kopa Menu\n1. Get Lima Loan\n2. Get Mavuno Loan\n3. Get Inputs Loan\n4. Pay Outstanding Loans",
  #         valid_responses: ["1", "2", "3", "4"],
  #         save_key: :kopa_menu_option,
  #         next_question: {"1" => 2, "2" => 5, "3" => 8, "4" => 11},
  #         error_message: "Sorry, that option is invalid. Kopa Menu\n1. Get Lima Loan\n2. Get Mavuno Loan\n3. Get Inputs Loan\n4. Pay Outstanding Loans\n5. Loans Main Menu"
  #       },
  #       2 => {
  #         question_text: "How many shillings do you require for your Lima Loan?",
  #         valid_responses: :any_number,
  #         save_key: :lima_loan_amount,
  #         next_question: 3,
  #         error_message: "Sorry, that option is invalid. How many shillings do you require for your Lima Loan?"
  #       },
  #       3 => {
  #         question_text: "You have requested a Lima Loan of KES #{@session[:lima_loan_amount]}. T&C's apply.\n1. Continue\n2. Cancel",
  #         valid_responses: ["1", "2"],
  #         save_key: :lima_loan_confirmation,
  #         next_question: {"1" => 4, "2" => 1},
  #         error_message: "Sorry, that option is invalid. You have requested a Lima Loan of KES #{@session[:lima_loan_amount]}. T&C's apply.\n1. Continue\n2. Cancel",
  #         next_form: :loans_main_menu
  #       },
  #       4 => {
  #         question_text: "Dear #{get_farmer.name}, you have been loaned #{@session[:lima_loan_amount]}, you should recieve this amount shortly via MPESA.",
  #         valid_responses: nil,
  #         save_key: :nil,
  #         next_question: nil,
  #         error_message: nil,
  #         post_action: :clear_lima_loan_params
  #       },
  #       5 => {
  #         question_text: "How many shillings do you require for your Mavuno Loan?",
  #         valid_responses: :any_number,
  #         save_key: :mavuno_loan_amount,
  #         next_question: 6,
  #         error_message: "Sorry, that option is invalid. How many shillings do you require for your Mavuno Loan?"
  #       },
  #       6 => {
  #         question_text: "You have requested a Mavuno Loan of KES #{@session[:mavuno_loan_amount]}. T&C's apply.\n1. Continue\n2. Cancel",
  #         valid_responses: ["1", "2"],
  #         save_key: :mavuno_loan_confirmation,
  #         next_question: {"1" => 7, "2" => 1},
  #         error_message: "Sorry, that option is invalid. You have requested a Mavuno Loan of KES #{@session[:mavuno_loan_amount]}. T&C's apply.\n1. Continue\n2. Cancel",
  #         next_form: :loans_main_menu
  #       },
  #       7 => {
  #         question_text: "Dear #{get_farmer.name}, you have been loaned #{@session[:mavuno_loan_amount]}, you should recieve this amount shortly via MPESA.",
  #         valid_responses: nil,
  #         save_key: :nil,
  #         next_question: nil,
  #         error_message: nil,
  #         post_action: :clear_mavuna_loan_params
  #       },
  #       8 => {
  #         question_text: "How many shillings do you require for your Input Voucher Loan?",
  #         valid_responses: :any_number,
  #         save_key: :input_voucher_loan_amount,
  #         next_question: 9,
  #         error_message: "Sorry, that option is invalid. How many shillings do you require for your Input Voucher Loan?"
  #       },
  #       9 => {
  #         question_text: "You have requested an Input Voucher Loan of KES #{@session[:input_voucher_loan_amount]}. T&C's apply.\n1. Continue\n2. Cancel",
  #         valid_responses: ["1", "2"],
  #         save_key: :input_voucher_loan_confirmation,
  #         next_question: {"1" => 10, "2" => 1},
  #         error_message: "Sorry, that option is invalid. You have requested an Input Voucher Loan of KES #{@session[:input_voucher_loan_amount]}. T&C's apply.\n1. Continue\n2. Cancel",
  #         next_form: :loans_main_menu
  #       },
  #       10 => {
  #         question_text: "Dear #{get_farmer.name}, you have been loaned with a voucher worth KES #{@session[:input_voucher_loan_amount]}, you should recieve your voucher code shortly via SMS.",
  #         valid_responses: nil,
  #         save_key: :nil,
  #         next_question: nil,
  #         error_message: nil,
  #         post_action: :clear_input_voucher_loan_params
  #       },
  #       11 => {
  #         question_text: "Pay Menu\nPay back your loan via the MPESA paybill number 123456\nPlease enter your ID as the a/c number",
  #         valid_responses: nil,
  #         save_key: nil,
  #         next_question: nil,
  #         error_message: nil
  #       },
  #     },
  #     model: Farmer,
  #     form_last_action: :save_loan
  #   }
  # end

  # def clear_lima_loan_params
  #   @session.delete :lima_loan_amount
  #   @session.delete :lima_loan_confirmation
  # end


  # def clear_mavuna_loan_params
  #   @session.delete :mavuno_loan_amount
  #   @session.delete :mavuno_loan_confirmation
  # end


  # def clear_input_voucher_loan_params
  #   @session.delete :input_voucher_loan_amount
  #   @session.delete :input_voucher_loan_confirmation
  # end

end