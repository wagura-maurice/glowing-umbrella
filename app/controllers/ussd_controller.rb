class UssdController < ApplicationController
  # Include required modules
  include Form

  # Set action method filters
  skip_before_filter :verify_authenticity_token
  skip_before_filter :require_login, :only => [:inbound]


  # Constructor
  def initialize
    @gateway = :africas_talking
  end
  
  # Accepts all incoming USSD requests and responds to them
  def inbound
    debugger
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
    if @last_question
      save_form_response
      # Start new form or send confirmation
      #send_confirmation
    end

    # Save session
    store_session

    # Render response
    render text: format_response(res, !@last_question)
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
      next_question: @next_question
    }
    @session = @session.merge session
    Rails.cache.write(@phone_number, @session)
  end

  # Returns whether a session exists for the incoming phone number
  def session_exists?
    return @session.present?
  end


  ###############################
  ### Session State Functions ###
  ###############################

  # Starts a new session
  # If the farmer exists, asks them to report crops if they have any
  # otherwise see if they want to start reporting crops
  # And if they dont exist, start by asking the farmer to register
  def start_new_session
    # 
    if farmer_exists?
      crops = get_farmer.crops
      if crops.present?
        form_name = get_crop_form_name(crops[0])
        new_session(form_name)
      else
        new_session(:update_farmer_crop_report_values)
      end
    else
      new_session(:user_registration)
    end

  end


  # Creates a new session
  def new_session(form)
    @phone_number = get_phone_number
    @current_form = form
    @form = self.send(@current_form)
    @current_question = get_form_start_id(form)
    @forms_filled = []
    @session = {}
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
    model.send(last_action, @session)
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
