module FormCallbacks


  ######################
  ### Form Callbacks ###
  ######################

  def run_before_next_question_callbacks
    callback = get_before_next_question_callbacks(@current_form, @current_question)
    if callback.present?
      self.send callback
    end
  end


  def perform_post_question_action
    action = get_form(@current_form)[:questions][@current_question][:post_action]
    if action.present?
      self.send(action)
    end
  end


end