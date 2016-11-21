module UssdSession

  ####################################
  ### Session Management Functions ###
  ####################################

  # Starts a new session
  # If the farmer exists send them to the home menu
  # Other ask the farmer to register
  def start_new_session
    if farmer_exists?
      new_session(:home_menu)
    else
      new_session(:user_registration)
    end
    @has_response = false
  end


  def get_session
    @phone_number = params["phoneNumber"]
    @session = Rails.cache.read(@phone_number)

    # Set instance variables based on session vars
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
    # Delete the dont_store_keys from the session obj
    #
    # Dont store keys are keys we keep in the session object for
    # only the current request. They are stored in the session object
    # instead of an instance var because the session object can be
    # passed to other models/objects more easily than instance vars
    dont_store_keys = [:dont_perform_new_report_in_request]
    dont_store_keys.each do |key|
      @session.delete key
    end

    session = {
      phone_number: @phone_number,
      current_form: @current_form,
      current_question: @current_question,
      forms_filled: @forms_filled,
      next_question: @next_question,
      forms_to_fill: @forms_to_fill
    }

    # Merge the @session instance var in case there are other key value
    # pairs we want to preserve for the next USSD requests
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


  ##################################
  ### Session Management Helpers ###
  ##################################

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


  ############################
  ### USSD Input Functions ###
  ############################

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
    @_farmer ||= Farmer.where(phone_number: get_phone_number).first
  end


end