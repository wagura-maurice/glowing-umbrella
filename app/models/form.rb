module Form

  # Require files
  require 'form_manager/form_getter'
  require 'form_manager/form_callbacks'
  require 'form_manager/form_validation'
  require 'forms/user_registration_form'
  require 'forms/crop_report_forms'
  require 'forms/home_menu_form'
  require 'forms/loan_forms'


  # Include modules
  include FormGetter
  include FormCallbacks
  include FormValidation
  include UserRegistrationForm
  include CropReportForms
  include HomeMenuForm
  include LoanForms


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
        run_before_next_question_callbacks
        move_to_next_question
        ret = get_text(@current_form, @current_question)
      else
        ret = get_error_message(@current_form, @current_question)
        if ret.is_a? Symbol
          ret = self.send ret
        end
        return ret
      end
    else
      return get_text(@current_form, @current_question)
    end
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
    elsif valid_responses == :any_year
      res = @response.to_i
      return res > 1900 && res < 2015
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


  # Returns TODO
  def has_response?
    if !@has_response.nil?
      return @has_response
    end
    return false if is_last_question? and !wait_for_response?
    return true if has_ussd_response?
    return false
  end

  # Saves the response to the current session
  def store_response
    save_key = get_save_key(@current_form, @current_question)
    @session[save_key] = @response
  end


  ###############################
  ### Form Movement Functions ###
  ###############################

  def move_to_next_question
    if wait_for_response?
      return go_to_next_form self.send @form[:questions][@current_question][:next_form]
    end
    if @next_question.is_a? Symbol
      @next_question = self.send(@next_question)
    end
    if @next_question.is_a? Hash
      @current_question = @next_question[@response]
    else
      @current_question = @next_question
    end
    @next_question = get_next_question
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

  ####################
  ### Form Helpers ###
  ####################

  def is_first_question?
    @current_question == start_id
  end

  # Returns whether the current question is the
  # last question for the current form
  def is_last_question?
    return false if @current_question.is_a? Hash
    question = get_question(@current_form, @current_question)
    return question[:next_question].nil?
  end


end
