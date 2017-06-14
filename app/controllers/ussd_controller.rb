class UssdController < ApplicationController

  # Require files
  require 'ussd/ussd_session'
  require 'ussd/format_request'
  require 'send_messages'


  # Include modules
  include Form
  include UssdSession
  include FormatRequest


  # Set action method filters
  skip_before_filter :verify_authenticity_token
  skip_before_filter :require_login, :only => [:inbound]
  before_filter :get_session, :only => :inbound

  # Constructor
  def initialize
    @gateway = :africas_talking
  end


  ######################
  ### Action Methods ###
  ######################

  # Accepts all incoming USSD requests and responds to them
  def inbound
    # If a session doesn't exist, start a new one
    start_new_session unless session_exists?
    # Get response
    res = respond_to_form

    # If the form has ended, save responses and decide on next steps
    form_ended = (is_last_question? and !is_first_question? and !wait_for_response?)
    if form_ended
      save_form_response

      # Start new form if it exists
      if has_next_form?
        perform_post_question_action
        go_to_next_form
        res = res + " " + respond_to_form
        form_ended = false
      end
    end

    # Do any post question action
    perform_post_question_action

    # Save session
    store_session

    # Render response
    render text: format_response(res, !form_ended)

    if is_last_question? && !has_next_form?
      msg = "Thank you for reporting on EAFF eGranary. EAFF will try and source for market for your harvest."
      SendMessages.send(@phone_number, 'eGRANARYKe', msg) unless Rails.env.development?
    end
  end


  protected



  #################################
  ### Form Management Functions ###
  #################################

  # Returns whether there are more forms for the farmer to fill
  def has_next_form?
    return remaining_forms.length > 0
  end


  # Returns the next form for the farmer to fill
  def get_next_form
    remainder = remaining_forms
    next_form = remainder[0]
    return next_form
  end


  # Returns a list of forms left for the farmer to fill
  def remaining_forms
    forms_to_fill = @forms_to_fill
    forms_filled = @forms_filled || []
    remainder = forms_to_fill - forms_filled
    return remainder
  end

  # Goes to the next form if it exists
  def go_to_next_form(form=nil)
    if form.present?
      new_form = form
    else
      new_form = get_next_form
    end

    if new_form
      @current_form = new_form
      @form = self.send(@current_form)
      @current_question = get_form_start_id(@current_form)
      @next_question = get_next_question
      @has_response = false unless wait_for_response?
    end
  end


  # Saves the form response to the database
  def save_form_response
    model = @form[:model]
    last_action = @form[:form_last_action]
    unless skip_last_action?(@current_form, @current_question)
      next_form = model.send(last_action, @session)
    end
    if next_form.present?
      @session[:forms_to_fill] << next_form
      @forms_to_fill << next_form
    end
    @forms_filled << @current_form
    @session[:forms_filled] << @current_form
  end


  #########################
  ### General Functions ###
  #########################

  # Gets the phone number from the params
  def get_phone_number
    @phone_number ||= params["phoneNumber"]
  end


end
