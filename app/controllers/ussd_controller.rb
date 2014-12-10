class UssdController < ApplicationController
  skip_before_filter :verify_authenticity_token
  skip_before_filter :require_login, :only => [:inbound]

  # where all USSD messages are routed to
  def inbound
    session_id = params["sessionId"]
    # if in cache, respond with the right message
    if (to_store = Rails.cache.read(session_id))
      res = gen_response(to_store[:state], params["text"])
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
