module FormGetter

  ############################
  ### Form Query Functions ###
  ############################

  # Returns a form
  def get_form(form_name)
    form = self.send(form_name)
    return form
  end


  # Gets the start id of the current form
  def start_id
    @form[:start_id]
  end


  def get_next_question
    next_question = get_form(@current_form)[:questions][@current_question][:next_question]
    return next_question
  end


  # Returns the question from a given form and question id
  def get_question(form_name, id)
    get_form(form_name)[:questions][id]
  end


  # Gets the id of the first question for a given form
  def get_form_start_id(form_name)
    get_form(form_name)[:start_id]
  end


  # Gets the save key for a given form and question id
  def get_save_key(form_name, question_id)
    get_form(form_name)[:questions][question_id][:save_key]
  end


  # Gets the question text for a given form and question id
  def get_text(form_name, question_id)
    text = get_form(form_name)[:questions][question_id][:question_text]
    if text.is_a? Symbol
      self.send text
    else
      return text
    end
  end


  # Gets the error message for a given form and question id
  def get_error_message(form_name, question_id)
    get_form(form_name)[:questions][question_id][:error_message]
  end


  # Gets the valid responses for a given form and question id
  def get_valid_responses(form_name, question_id)
    resp = get_form(form_name)[:questions][question_id][:valid_responses]
    if resp.is_a? Symbol and !FormValidation::RESPONSE_TYPES.include?(resp)
      resp = self.send(resp)
    end
    return resp
  end


  # Returns the form name for a given crop
  def get_crop_form_name(crop)
    form_name = (crop.to_s + "_report").to_sym
  end


  # Gets the callback function to run before moving on to the next question
  def get_before_next_question_callbacks(form_name, question_id)
    get_form(form_name)[:questions][question_id][:before_next_question_callback]
  end


  # Gets the model for the form
  def get_form_model(form_name)
    get_form(form_name)[:model]
  end


  # Gets the form last action
  def get_form_last_action(form_name)
    get_form(form_name)[:form_last_action]
  end

  def skip_last_action?(form_name, question_id)
    get_form(form_name)[:questions][question_id][:skip_last_action] == true
  end

end