class UssdController < ApplicationController
  # Include required modules
  include Form
  require 'send_messages'

  # Set action method filters
  skip_before_filter :verify_authenticity_token
  skip_before_filter :require_login, :only => [:inbound]


  # Constructor
  def initialize
    @gateway = :africas_talking
  end

  # Accepts all incoming USSD requests and responds to them
  def inbound
    # Get the session if it exists
    get_session

    # If it exists, continue it
    if session_exists?


    # If a session doesn't exist, start a new one
    else
      start_new_session
    end

    # Get response
    res = respond_to_form


    # If the form has ended, save responses and decide on next steps
    if is_last_question? and !is_first_question? and !wait_for_response?
      save_form_response

      # Start new form if it exists
      if has_next_form?
        go_to_next_form
        res = res + " " + respond_to_form
      end
    end

    # Save session
    store_session


    # Render response
    render text: format_response(res, !(is_last_question? and !is_first_question? and !has_next_form? and !wait_for_response?))

    if is_last_question? && !has_next_form?
      msg = "Thank you for reporting on on EAFF eGranary. EAFF will try and source for market for your harvest."
      SendMessages.send(@phone_number, 'Jiunga', msg) unless Rails.env.development?
    end
  end


  protected


  ####################################
  ### Session Management Functions ###
  ####################################

  def get_session
    @phone_number = params["phoneNumber"]
    @session = Rails.cache.read(@phone_number)
    if @session
      @current_form = @session[:current_form]
      @current_question = @session[:current_question]
      @forms_filled = @session[:forms_filled]
      @next_question = @session[:next_question]
      @form = self.send(@current_form)
      @forms_to_fill = @session[:forms_to_fill]
    end
    if has_ussd_response?
      @response = get_ussd_response
    end
  end


  def store_session
    session = {
      phone_number: @phone_number,
      current_form: @current_form,
      current_question: @current_question,
      forms_filled: @forms_filled,
      next_question: @next_question,
      forms_to_fill: @forms_to_fill
    }
    @session = @session.merge session
    Rails.cache.write(@phone_number, @session, expires_in: 12.hour)
  end

  # Returns whether a session exists for the incoming phone number
  def session_exists?
    return @session.present?
  end


  def add_to_session(key, value)
    @session[key] = value
  end

  ###############################
  ### Session State Functions ###
  ###############################

  # Starts a new session
  # If the farmer exists, asks them to report crops if they have any
  # otherwise see if they want to start reporting crops
  # And if they dont exist, start by asking the farmer to register
  def start_new_session
    if farmer_exists?
      new_session(:home_menu)
    else
      new_session(:user_registration)
    end
    @has_response = false
  end


  # Creates a new session
  def new_session(form)
    @phone_number = get_phone_number
    @current_form = form
    @form = self.send(@current_form)
    @current_question = get_form_start_id(form)
    @forms_filled = []
    @session = {}
    @next_question = get_next_question
    @forms_to_fill = []
    store_session
  end


  # Returns whether there is a current USSD response
  def has_ussd_response?
    params["text"].present?
  end


  # Returns the current USSD response
  def get_ussd_response
    if has_ussd_response?
      return params["text"].split('*')[-1]
    end
  end

  ###################################
  ### Farmer Management Functions ###
  ###################################

  # Does a farmer exist given the current phone_number
  def farmer_exists?
    Farmer.where(phone_number: get_phone_number).exists?
  end


  # Return a farmer object given the current phone_number
  def get_farmer
    Farmer.where(phone_number: get_phone_number).first
  end

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
#    unless remainder[0].to_s.include? "_report"
#      next_form = (remainder[0].to_s + "_report").to_sym
#    else
    next_form = remainder[0]
#    end
    return next_form
  end


  # Returns a list of forms left for the farmer to fill
  def remaining_forms
    #crops = get_farmer.crops || []
    #crop_reports = crops.map {|c| (c + "_report").to_sym}
    forms_to_fill = @forms_to_fill
    forms_filled = @forms_filled || []
    remainder = forms_to_fill - forms_filled
    return remainder
  end

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

  #########################
  ### General Functions ###
  #########################

  # Gets the phone number from the params
  def get_phone_number
    @phone_number ||= params["phoneNumber"]
  end


  # Saves the form respons to the database
  def save_form_response
    model = @form[:model]
    last_action = @form[:form_last_action]
    next_form = model.send(last_action, @session)
    if next_form.present?
      @session[:forms_to_fill] << next_form
      @forms_to_fill << next_form
    end
    @forms_filled << @current_form
    @session[:forms_filled] << @current_form
  end


  # Formats the form response for the USSD gateway
  def format_response(response, continue)
    if @gateway == :africas_talking
      if continue
        response = "CON " + response
      else
        response = "END " + response
      end
    end
    return response
  end

end
