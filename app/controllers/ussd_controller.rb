class UssdController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :require_login, :only => [:inbound2]

  def initialize
    @gateway = :africas_talking
  end
  
  def inbound2
    # If a session exists, continue it
    if session_exists?
      
      # if its the last step of the session, check the type of session
      if Form.is_last_question?(form_session)
        debugger
        response_valid = Form.expensive_response_valid(session_id, get_ussd_response)

        if response_valid
          res = Form.respond_to_form(session_id, get_ussd_response)
          perform_form_last_action
          session = form_session
          session[:forms_filled] << session[:current_form]
          store_session(session)

          # if there is another form, start that
          if has_next_form?
            go_to_next_form
            res = res + " " + Form.respond_to_form(session_id, get_ussd_response)

          # otherwise show the form end message
          else
            res = Form.respond_to_form(session_id, get_ussd_response)
          end

        else
          res = Form.respond_to_form(session_id, get_ussd_response)
        end
      # Otherwise just continue the session
      else
        res = Form.respond_to_form(session_id, get_ussd_response)
      end

    # else start a new session  
    else
      # if the farmer exists, start a crop report session
      if farmer_exists?
        crops = get_farmer.crops
        if crops.present?
            form_name = (crops[0].to_s + "_report").to_sym
            session = new_session(form_name)
            store_session(session)
            res = Form.respond_to_form(session_id, get_ussd_response)
        else
          res = "There are no crops to report"
        end

      # if the farmer doesnt exist, start a user registration session
      else
        session = new_session(:user_registration)        
        store_session(session)
        res = Form.respond_to_form(session_id)
      end
    end
    last_question = Form.is_last_question?(form_session)
    render text: format_response(res, !last_question)
  end


  protected

  def has_next_form?
    current_form = form_session[:current_form]
    farmer = get_farmer
    crops = farmer.crops || []
    crop_reports = crops.map {|c| (c + "_report").to_sym}
    forms_filled = form_session[:forms_filled] || []
    remainder = crop_reports - forms_filled
    return remainder.length > 0
  end

  def get_next_form
    current_form = form_session[:current_form]
    farmer = get_farmer
    crops = farmer.crops || []
    crop_reports = crops.map {|c| (c + "_report").to_sym}
    forms_filled = form_session[:forms_filled] || []
    remainder = crop_reports - forms_filled
    unless remainder[0].to_s.include? "_report"
      next_form = (remainder[0].to_s + "_report").to_sym
    else
      next_form = remainder[0]
    end
    return next_form
  end

  def perform_form_last_action
    session = form_session
    form = Form.send(session[:current_form])
    model = form[:model]
    last_action = form[:form_last_action]
    model.send(last_action, session)
  end

  def has_ussd_response?
    params["text"].present?
  end

  def get_ussd_response
    if params["text"].present?
      text = params["text"].split('*')[-1]
    end
  end

  def new_session(form)
    {session_id: session_id,
     current_form: form,
     question: get_form_start_id(form),
     phone_number: get_phone_number,
     forms_filled: []
    }
  end

  def farmer_exists?
    Farmer.where(phone_number: get_phone_number).exists?
  end

  def get_farmer
    Farmer.where(phone_number: get_phone_number).first
  end

  def get_phone_number
    params["phoneNumber"]
  end

  def session_exists?
    form_session.present?
  end

  def go_to_next_form
    session = form_session
    session[:forms_filled] << session[:current_form]
    new_form = get_next_form
    session[:current_form] = new_form
    session[:question] = get_form_start_id(new_form)
    store_session(session)
  end

  def get_form_start_id(form)
    Form.send(form)[:start_id]
  end

  def form_session
    @session = @session || Rails.cache.read(session_id)
    return @session
  end

  def session_id
    params["sessionId"]
  end

  def form_text
    if has_text?
      return params["text"].split('*')[-1]
    end
  end

  def has_text?
    params["text"].present?
  end

  def store_session(session)
    @session = session
    Rails.cache.write(session_id, session)
  end

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


  # where all USSD messages are routed to
  def inbound
    session_id = params["sessionId"]
    if params["text"].present?
      text = params["text"].split('*')[-1]
    end
    # if in cache, respond with the right message
    if (to_store = Rails.cache.read(session_id))
      res = gen_response(to_store[:state], text)
      new_store = to_store.merge(res)
      Rails.cache.write(session_id, new_store)
      if new_store[:state] == 5
        # Give the farmer input a user
        superuser = User.where(username: 'modedemo').first
        FarmerInput.create(warehouse_number: new_store[:warehouse_number],
                           commodity_number: new_store[:commodity_number],
                           quantity: new_store[:quantity],
                           commodity_grade: new_store[:grade],
                           phone_number: new_store[:phone_number],
                           session_id: new_store[:session_id],
                           state: new_store[:state],
                           user: superuser)
      end
    # else if not in cache, write to cache, give it a state of 0 and respond with message
    else
      to_store = {session_id: session_id, state: 0, phone_number: params['phoneNumber']}
      res = gen_response(0)
      new_store = to_store.merge(res)
      Rails.cache.write(session_id, new_store)
    end
    render text: res[:msg]
  end


  private 

  # generates a response
  def gen_response(state, text=nil)
    case state
    when 0
      msg = "CON Enter warehouse number: \n"
      ret = {msg: msg, state: 1}
    when 1
      warehouse_number = text.to_i
      if valid_warehouses.include? warehouse_number
        msg = get_commodity_list_msg
        ret = {msg: msg, state: 2, warehouse_number: warehouse_number}
      else
        msg = "CON Invalid warehouse number. \nPlease try again, enter warehouse number: \n"
        ret = {msg: msg, state: 1}
      end
    when 2
      commodity_number = text.to_i
      if valid_commodities.include? commodity_number
        msg = "CON Enter quantity in kg: \n"
        ret = {msg: msg, state: 3, commodity_number: commodity_number}
      else
        msg = "CON Invalid commodity. \nPlease try again, which commodity do you grow? \n1. Coffee \n2. Tea \n3. Cabbage \n4. Mangoes \n5. Bananas \n"
        ret = {msg: msg, state: 2}
      end
    when 3
      quantity = text.to_f
      msg = get_commodity_grade
      ret = {msg: msg, state: 4, quantity: quantity}
    when 4
      grade = text.to_i
      if valid_commodity_grades.include? grade
        msg = "END Thanks for logging your farm output. We will notify buyers promptly \n"
        ret = {msg: msg, state: 5, grade: grade}
      else
        msg = "CON Invalid grade, please try again \n" + get_commodity_grade
        ret = {msg: msg, state: 4}
      end
    else
      msg = "END Sorry, there was an error in the form. Please try again. \n"
      ret = {msg: msg, state: 0}
    end
    return ret
  end

  def valid_warehouses
    return [1, 2, 3]
  end

  def valid_commodities
    return [1, 2, 3, 4, 5]
  end

  def valid_commodity_grades
    return [1, 2, 3, 4, 5]
  end

  def get_commodity_list_msg
    "CON Which commodity do you grow? \n1. Coffee \n2. Tea \n3. Cabbage \n4. Mangoes \n5. Bananas \n"
  end

  def get_commodity_grade
    "CON Enter commodity grade: \n1. Speciality \n2. Premium \n3. Exchange \n4. Standard \n5. Off Grade \n"
  end

end
