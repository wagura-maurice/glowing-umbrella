class UssdController < ApplicationController
  # Include required modules
  include Form

  # Set action method filters
  skip_before_filter :verify_authenticity_token
  skip_before_filter :require_login, :only => [:inbound2]


  # Constructor
  def initialize
    @gateway = :africas_talking
  end
  
  # Accepts all incoming USSD requests and responds to them
  def inbound

  end


  protected


  def store_session
    session = {
      phone_number: @phone_number,
      current_form: @current_form,
      question_id: @question_id,
      forms_filled: @forms_filled,
    }
    Rails.cache.write(@phone_number, session)
  end


end
