module PlantingInputsForms

  def maize_report
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "How many KG of seeds do you want to plant?",
          valid_responses: :any_number,
          save_key: :kg_of_seed,
          next_question: 2,
          error_message: "You're response was not valid. How many KG of seeds do you want to plant?"
        },
        2 => {
          question_text: "Which type of planting fertilizer do you want? \n1. D.A.P \n2. N.P.K (23:23:0)",
          valid_responses: ["1", "2"],
          save_key: :type_of_planting_fertilizer,
          next_question: {"1" => 3, "2" => 4},
          error_message: "You're response was not valid. Which type of planting fertilizer do you want? \n1. D.A.P \n2. N.P.K (23:23:0)"
        },
        3 => {
          question_text: "How many bags of 50KG D.A.P planting fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_dap_fertilizer,
          next_question: 5,
          error_message: "You're response was not valid. How many bags of 50KG D.A.P planting fertilizer do you want?"
        },
        4 => {
          question_text: "How many bags of 50KG NPK (23:23:0) planting fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_npk_fertilizer,
          next_question: 5,
          error_message: "You're response was not valid. How many bags of 50KG NPK (23:23:0) planting fertilizer do you want?"
        },
        5 => {
          question_text: "How many bags of 50KG C.A.N top dressing fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_can_fertilizer,
          next_question: 6,
          error_message: "You're response was not valid. How many bags of 50KG C.A.N top dressing fertilizer do you want?"
        },
        6 => {
          question_text: "Which Agro-Chemical do you want to use?",
          valid_responses: :any_letters,
          save_key: :agro_chem,
          next_question: 7,
          error_message: "You're response was not valid. Which Agro-Chemical do you want to use?"
        },
        7 => {
          question_text: "How many acres of Maize are you planting?",
          valid_responses: :any_number,
          save_key: :acres_planting,
          next_question: 8,
          error_message: "You're response was not valid. How many acres of Maize are you planting?"
        },
        8 => {
          question_text: "Request for other crops, your planting? \n1. Yes \n2. No",
          valid_responses: ["1", "2"],
          save_key: :other_crops_harvested,
          before_next_question_callback: :save_input_data,
          next_question: {"1" => 10, "2" => 9},
          error_message: "You're response was not valid. Request for other crops, your planting? \n1. Yes \n2. No"
        },
        9 => {
          question_text: "Thank you for requesting on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        },
        10 => {
          question_text: :get_inputs_menu_text,
          valid_responses: :get_inputs_menu_valid_responses,
          save_key: :planting_inputs,
          next_question: nil,
          wait_until_response: true,
          next_form: :get_report_inputs_form,
          error_message: :get_inputs_menu_error_message
        }
      },
      model: MaizeInput,
      form_last_action: :new_input
    }
  end


  def rice_report
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "How many KG of seeds do you want to plant?",
          valid_responses: :any_number,
          save_key: :kg_of_seed,
          next_question: 2,
          error_message: "You're response was not valid. How many KG of seeds do you want to plant?"
        },
        2 => {
          question_text: "Which type of planting fertilizer do you want? \n1. D.A.P \n2. N.P.K (23:23:0)",
          valid_responses: ["1", "2"],
          save_key: :type_of_planting_fertilizer,
          next_question: {"1" => 3, "2" => 4},
          error_message: "You're response was not valid. Which type of planting fertilizer do you want? \n1. D.A.P \n2. N.P.K (23:23:0)"
        },
        3 => {
          question_text: "How many bags of 50KG D.A.P planting fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_dap_fertilizer,
          next_question: 5,
          error_message: "You're response was not valid. How many bags of 50KG D.A.P planting fertilizer do you want?"
        },
        4 => {
          question_text: "How many bags of 50KG NPK (23:23:0) planting fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_npk_fertilizer,
          next_question: 5,
          error_message: "You're response was not valid. How many bags of 50KG NPK (23:23:0) planting fertilizer do you want?"
        },
        5 => {
          question_text: "How many bags of 50KG C.A.N top dressing fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_can_fertilizer,
          next_question: 6,
          error_message: "You're response was not valid. How many bags of 50KG C.A.N top dressing fertilizer do you want?"
        },
        6 => {
          question_text: "Which Agro-Chemical do you want to use?",
          valid_responses: :any_letters,
          save_key: :agro_chem,
          next_question: 7,
          error_message: "You're response was not valid. Which Agro-Chemical do you want to use?"
        },
        7 => {
          question_text: "How many acres of Rice are you planting?",
          valid_responses: :any_number,
          save_key: :acres_planting,
          next_question: 8,
          error_message: "You're response was not valid. How many acres of Rice are you planting?"
        },
        8 => {
          question_text: "Request for other crops, your planting? \n1. Yes \n2. No",
          valid_responses: ["1", "2"],
          save_key: :other_crops_harvested,
          before_next_question_callback: :save_input_data,
          next_question: {"1" => 10, "2" => 9},
          error_message: "You're response was not valid. Request for other crops, your planting? \n1. Yes \n2. No"
        },
        9 => {
          question_text: "Thank you for requesting on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        },
        10 => {
          question_text: :get_inputs_menu_text,
          valid_responses: :get_inputs_menu_valid_responses,
          save_key: :planting_inputs,
          next_question: nil,
          wait_until_response: true,
          next_form: :get_report_inputs_form,
          error_message: :get_inputs_menu_error_message
        }
      },
      model: RiceInput,
      form_last_action: :new_input
    }
  end

  def nerica_rice_report
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "How many KG of seeds do you want to plant?",
          valid_responses: :any_number,
          save_key: :kg_of_seed,
          next_question: 2,
          error_message: "You're response was not valid. How many KG of seeds do you want to plant?"
        },
        2 => {
          question_text: "Which type of planting fertilizer do you want? \n1. D.A.P \n2. N.P.K (23:23:0)",
          valid_responses: ["1", "2"],
          save_key: :type_of_planting_fertilizer,
          next_question: {"1" => 3, "2" => 4},
          error_message: "You're response was not valid. Which type of planting fertilizer do you want? \n1. D.A.P \n2. N.P.K (23:23:0)"
        },
        3 => {
          question_text: "How many bags of 50KG D.A.P planting fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_dap_fertilizer,
          next_question: 5,
          error_message: "You're response was not valid. How many bags of 50KG D.A.P planting fertilizer do you want?"
        },
        4 => {
          question_text: "How many bags of 50KG NPK (23:23:0) planting fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_npk_fertilizer,
          next_question: 5,
          error_message: "You're response was not valid. How many bags of 50KG NPK (23:23:0) planting fertilizer do you want?"
        },
        5 => {
          question_text: "How many bags of 50KG C.A.N top dressing fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_can_fertilizer,
          next_question: 6,
          error_message: "You're response was not valid. How many bags of 50KG C.A.N top dressing fertilizer do you want?"
        },
        6 => {
          question_text: "Which Agro-Chemical do you want to use?",
          valid_responses: :any_letters,
          save_key: :agro_chem,
          next_question: 7,
          error_message: "You're response was not valid. Which Agro-Chemical do you want to use?"
        },
        7 => {
          question_text: "How many acres of Nerica Rice are you planting?",
          valid_responses: :any_number,
          save_key: :acres_planting,
          next_question: 8,
          error_message: "You're response was not valid. How many acres of Nerica Rice are you planting?"
        },
        8 => {
          question_text: "Request for other crops, your planting? \n1. Yes \n2. No",
          valid_responses: ["1", "2"],
          save_key: :other_crops_harvested,
          before_next_question_callback: :save_input_data,
          next_question: {"1" => 10, "2" => 9},
          error_message: "You're response was not valid. Request for other crops, your planting? \n1. Yes \n2. No"
        },
        9 => {
          question_text: "Thank you for requesting on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        },
        10 => {
          question_text: :get_inputs_menu_text,
          valid_responses: :get_inputs_menu_valid_responses,
          save_key: :planting_inputs,
          next_question: nil,
          wait_until_response: true,
          next_form: :get_report_inputs_form,
          error_message: :get_inputs_menu_error_message
        }
      },
      model: NericaRiceInput,
      form_last_action: :new_input
    }
  end

  def beans_report
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "How many KG of seeds do you want to plant?",
          valid_responses: :any_number,
          save_key: :kg_of_seed,
          next_question: 2,
          error_message: "You're response was not valid. How many KG of seeds do you want to plant?"
        },
        2 => {
          question_text: "Which type of planting fertilizer do you want? \n1. D.A.P \n2. N.P.K (23:23:0)",
          valid_responses: ["1", "2"],
          save_key: :type_of_planting_fertilizer,
          next_question: {"1" => 3, "2" => 4},
          error_message: "You're response was not valid. Which type of planting fertilizer do you want? \n1. D.A.P \n2. N.P.K (23:23:0)"
        },
        3 => {
          question_text: "How many bags of 50KG D.A.P planting fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_dap_fertilizer,
          next_question: 5,
          error_message: "You're response was not valid. How many bags of 50KG D.A.P planting fertilizer do you want?"
        },
        4 => {
          question_text: "How many bags of 50KG NPK (23:23:0) planting fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_npk_fertilizer,
          next_question: 5,
          error_message: "You're response was not valid. How many bags of 50KG NPK (23:23:0) planting fertilizer do you want?"
        },
        5 => {
          question_text: "How many bags of 50KG C.A.N top dressing fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_can_fertilizer,
          next_question: 6,
          error_message: "You're response was not valid. How many bags of 50KG C.A.N top dressing fertilizer do you want?"
        },
        6 => {
          question_text: "Which Agro-Chemical do you want to use?",
          valid_responses: :any_letters,
          save_key: :agro_chem,
          next_question: 7,
          error_message: "You're response was not valid. Which Agro-Chemical do you want to use?"
        },
        7 => {
          question_text: "How many acres of Beans are you planting?",
          valid_responses: :any_number,
          save_key: :acres_planting,
          next_question: 8,
          error_message: "You're response was not valid. How many acres of Beans are you planting?"
        },
        8 => {
          question_text: "Request for other crops, your planting? \n1. Yes \n2. No",
          valid_responses: ["1", "2"],
          save_key: :other_crops_harvested,
          before_next_question_callback: :save_input_data,
          next_question: {"1" => 10, "2" => 9},
          error_message: "You're response was not valid. Request for other crops, your planting? \n1. Yes \n2. No"
        },
        9 => {
          question_text: "Thank you for requesting on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        },
        10 => {
          question_text: :get_inputs_menu_text,
          valid_responses: :get_inputs_menu_valid_responses,
          save_key: :planting_inputs,
          next_question: nil,
          wait_until_response: true,
          next_form: :get_report_inputs_form,
          error_message: :get_inputs_menu_error_message
        }
      },
      model: BeansInput,
      form_last_action: :new_input
    }
  end

  def green_grams_report
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "How many KG of seeds do you want to plant?",
          valid_responses: :any_number,
          save_key: :kg_of_seed,
          next_question: 2,
          error_message: "You're response was not valid. How many KG of seeds do you want to plant?"
        },
        2 => {
          question_text: "Which type of planting fertilizer do you want? \n1. D.A.P \n2. N.P.K (23:23:0)",
          valid_responses: ["1", "2"],
          save_key: :type_of_planting_fertilizer,
          next_question: {"1" => 3, "2" => 4},
          error_message: "You're response was not valid. Which type of planting fertilizer do you want? \n1. D.A.P \n2. N.P.K (23:23:0)"
        },
        3 => {
          question_text: "How many bags of 50KG D.A.P planting fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_dap_fertilizer,
          next_question: 5,
          error_message: "You're response was not valid. How many bags of 50KG D.A.P planting fertilizer do you want?"
        },
        4 => {
          question_text: "How many bags of 50KG NPK (23:23:0) planting fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_npk_fertilizer,
          next_question: 5,
          error_message: "You're response was not valid. How many bags of 50KG NPK (23:23:0) planting fertilizer do you want?"
        },
        5 => {
          question_text: "How many bags of 50KG C.A.N top dressing fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_can_fertilizer,
          next_question: 6,
          error_message: "You're response was not valid. How many bags of 50KG C.A.N top dressing fertilizer do you want?"
        },
        6 => {
          question_text: "Which Agro-Chemical do you want to use?",
          valid_responses: :any_letters,
          save_key: :agro_chem,
          next_question: 7,
          error_message: "You're response was not valid. Which Agro-Chemical do you want to use?"
        },
        7 => {
          question_text: "How many acres of Green Grams are you planting?",
          valid_responses: :any_number,
          save_key: :acres_planting,
          next_question: 8,
          error_message: "You're response was not valid. How many acres of Green Grams are you planting?"
        },
        8 => {
          question_text: "Request for other crops, your planting? \n1. Yes \n2. No",
          valid_responses: ["1", "2"],
          save_key: :other_crops_harvested,
          before_next_question_callback: :save_input_data,
          next_question: {"1" => 10, "2" => 9},
          error_message: "You're response was not valid. Request for other crops, your planting? \n1. Yes \n2. No"
        },
        9 => {
          question_text: "Thank you for requesting on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        },
        10 => {
          question_text: :get_inputs_menu_text,
          valid_responses: :get_inputs_menu_valid_responses,
          save_key: :planting_inputs,
          next_question: nil,
          wait_until_response: true,
          next_form: :get_report_inputs_form,
          error_message: :get_inputs_menu_error_message
        }
      },
      model: GreenGramsInput,
      form_last_action: :new_input
    }
  end

  def black_eyed_beans_report
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "How many KG of seeds do you want to plant?",
          valid_responses: :any_number,
          save_key: :kg_of_seed,
          next_question: 2,
          error_message: "You're response was not valid. How many KG of seeds do you want to plant?"
        },
        2 => {
          question_text: "Which type of planting fertilizer do you want? \n1. D.A.P \n2. N.P.K (23:23:0)",
          valid_responses: ["1", "2"],
          save_key: :type_of_planting_fertilizer,
          next_question: {"1" => 3, "2" => 4},
          error_message: "You're response was not valid. Which type of planting fertilizer do you want? \n1. D.A.P \n2. N.P.K (23:23:0)"
        },
        3 => {
          question_text: "How many bags of 50KG D.A.P planting fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_dap_fertilizer,
          next_question: 5,
          error_message: "You're response was not valid. How many bags of 50KG D.A.P planting fertilizer do you want?"
        },
        4 => {
          question_text: "How many bags of 50KG NPK (23:23:0) planting fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_npk_fertilizer,
          next_question: 5,
          error_message: "You're response was not valid. How many bags of 50KG NPK (23:23:0) planting fertilizer do you want?"
        },
        5 => {
          question_text: "How many bags of 50KG C.A.N top dressing fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_can_fertilizer,
          next_question: 6,
          error_message: "You're response was not valid. How many bags of 50KG C.A.N top dressing fertilizer do you want?"
        },
        6 => {
          question_text: "Which Agro-Chemical do you want to use?",
          valid_responses: :any_letters,
          save_key: :agro_chem,
          next_question: 7,
          error_message: "You're response was not valid. Which Agro-Chemical do you want to use?"
        },
        7 => {
          question_text: "How many acres of Black Eyed Beans are you planting?",
          valid_responses: :any_number,
          save_key: :acres_planting,
          next_question: 8,
          error_message: "You're response was not valid. How many acres of Black Eyed Beans are you planting?"
        },
        8 => {
          question_text: "Request for other crops, your planting? \n1. Yes \n2. No",
          valid_responses: ["1", "2"],
          save_key: :other_crops_harvested,
          before_next_question_callback: :save_input_data,
          next_question: {"1" => 10, "2" => 9},
          error_message: "You're response was not valid. Request for other crops, your planting? \n1. Yes \n2. No"
        },
        9 => {
          question_text: "Thank you for requesting on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        },
        10 => {
          question_text: :get_inputs_menu_text,
          valid_responses: :get_inputs_menu_valid_responses,
          save_key: :planting_inputs,
          next_question: nil,
          wait_until_response: true,
          next_form: :get_report_inputs_form,
          error_message: :get_inputs_menu_error_message
        }
      },
      model: BlackEyedBeansInput,
      form_last_action: :new_input
    }
  end

  def soya_beans_report
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "How many KG of seeds do you want to plant?",
          valid_responses: :any_number,
          save_key: :kg_of_seed,
          next_question: 2,
          error_message: "You're response was not valid. How many KG of seeds do you want to plant?"
        },
        2 => {
          question_text: "Which type of planting fertilizer do you want? \n1. D.A.P \n2. N.P.K (23:23:0)",
          valid_responses: ["1", "2"],
          save_key: :type_of_planting_fertilizer,
          next_question: {"1" => 3, "2" => 4},
          error_message: "You're response was not valid. Which type of planting fertilizer do you want? \n1. D.A.P \n2. N.P.K (23:23:0)"
        },
        3 => {
          question_text: "How many bags of 50KG D.A.P planting fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_dap_fertilizer,
          next_question: 5,
          error_message: "You're response was not valid. How many bags of 50KG D.A.P planting fertilizer do you want?"
        },
        4 => {
          question_text: "How many bags of 50KG NPK (23:23:0) planting fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_npk_fertilizer,
          next_question: 5,
          error_message: "You're response was not valid. How many bags of 50KG NPK (23:23:0) planting fertilizer do you want?"
        },
        5 => {
          question_text: "How many bags of 50KG C.A.N top dressing fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_can_fertilizer,
          next_question: 6,
          error_message: "You're response was not valid. How many bags of 50KG C.A.N top dressing fertilizer do you want?"
        },
        6 => {
          question_text: "Which Agro-Chemical do you want to use?",
          valid_responses: :any_letters,
          save_key: :agro_chem,
          next_question: 7,
          error_message: "You're response was not valid. Which Agro-Chemical do you want to use?"
        },
        7 => {
          question_text: "How many acres of Soya Beans are you planting?",
          valid_responses: :any_number,
          save_key: :acres_planting,
          next_question: 8,
          error_message: "You're response was not valid. How many acres of Soya Beans are you planting?"
        },
        8 => {
          question_text: "Request for other crops, your planting? \n1. Yes \n2. No",
          valid_responses: ["1", "2"],
          save_key: :other_crops_harvested,
          before_next_question_callback: :save_input_data,
          next_question: {"1" => 10, "2" => 9},
          error_message: "You're response was not valid. Request for other crops, your planting? \n1. Yes \n2. No"
        },
        9 => {
          question_text: "Thank you for requesting on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        },
        10 => {
          question_text: :get_inputs_menu_text,
          valid_responses: :get_inputs_menu_valid_responses,
          save_key: :planting_inputs,
          next_question: nil,
          wait_until_response: true,
          next_form: :get_report_inputs_form,
          error_message: :get_inputs_menu_error_message
        }
      },
      model: SoyaBeansInput,
      form_last_action: :new_input
    }
  end

  def pigeon_peas_report
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "How many KG of seeds do you want to plant?",
          valid_responses: :any_number,
          save_key: :kg_of_seed,
          next_question: 2,
          error_message: "You're response was not valid. How many KG of seeds do you want to plant?"
        },
        2 => {
          question_text: "Which type of planting fertilizer do you want? \n1. D.A.P \n2. N.P.K (23:23:0)",
          valid_responses: ["1", "2"],
          save_key: :type_of_planting_fertilizer,
          next_question: {"1" => 3, "2" => 4},
          error_message: "You're response was not valid. Which type of planting fertilizer do you want? \n1. D.A.P \n2. N.P.K (23:23:0)"
        },
        3 => {
          question_text: "How many bags of 50KG D.A.P planting fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_dap_fertilizer,
          next_question: 5,
          error_message: "You're response was not valid. How many bags of 50KG D.A.P planting fertilizer do you want?"
        },
        4 => {
          question_text: "How many bags of 50KG NPK (23:23:0) planting fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_npk_fertilizer,
          next_question: 5,
          error_message: "You're response was not valid. How many bags of 50KG NPK (23:23:0) planting fertilizer do you want?"
        },
        5 => {
          question_text: "How many bags of 50KG C.A.N top dressing fertilizer do you want?",
          valid_responses: :any_number,
          save_key: :bags_of_can_fertilizer,
          next_question: 6,
          error_message: "You're response was not valid. How many bags of 50KG C.A.N top dressing fertilizer do you want?"
        },
        6 => {
          question_text: "Which Agro-Chemical do you want to use?",
          valid_responses: :any_letters,
          save_key: :agro_chem,
          next_question: 7,
          error_message: "You're response was not valid. Which Agro-Chemical do you want to use?"
        },
        7 => {
          question_text: "How many acres of Pigeon Peas are you planting?",
          valid_responses: :any_number,
          save_key: :acres_planting,
          next_question: 8,
          error_message: "You're response was not valid. How many acres of Pigeon Peas are you planting?"
        },
        8 => {
          question_text: "Request for other crops, your planting? \n1. Yes \n2. No",
          valid_responses: ["1", "2"],
          save_key: :other_crops_harvested,
          before_next_question_callback: :save_input_data,
          next_question: {"1" => 10, "2" => 9},
          error_message: "You're response was not valid. Request for other crops, your planting? \n1. Yes \n2. No"
        },
        9 => {
          question_text: "Thank you for requesting on EAFF eGranary.",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        },
        10 => {
          question_text: :get_inputs_menu_text,
          valid_responses: :get_inputs_menu_valid_responses,
          save_key: :planting_inputs,
          next_question: nil,
          wait_until_response: true,
          next_form: :get_report_inputs_form,
          error_message: :get_inputs_menu_error_message
        }
      },
      model: PigeonPeasInput,
      form_last_action: :new_input
    }
  end

  def get_inputs_menu_text
    farmer = get_farmer
    two_months_ago = Time.now - 60 * 60 * 24 * 60

    ret = "want do you want to plant this season? "
    can_report = {}

    # Want to show all crops that we have a planting report for but not a harvest report in the last 2 months
    i = 1
    CROPS.each do |crop_name, data|
      crop_report = data[:model]
        ret += "\n#{i}. #{data[:text]}"
        can_report[i] = crop_name
        i += 1
    end

    can_report[i] = :home_menu
    add_to_session(:inputs_reports_available, can_report)
    ret += "\n#{i}. Return to main menu"
    return ret

  end

  def get_inputs_menu_valid_responses
    return :any if @session[:inputs_reports_available].nil?
    return :any if @session[:inputs_reports_available].length == 0
    ret = []
    @session[:inputs_reports_available].each do |k, v|
      ret << k.to_s
    end
    return ret
  end

  def get_inputs_menu_error_message
    ret = "Sorry, that answer was not valid. "
    ret += get_inputs_menu_text
    return ret
  end

  def get_report_inputs_form
    if !@session[:inputs_reports_available].nil? and @session[:inputs_reports_available].length == 0
      return :home_menu
    end
    crop = @session[:inputs_reports_available][@response.to_i]
    if crop == :home_menu
      @session.delete :plant_or_harvest
      @session.delete :planting_inputs
      return :home_menu
    end
    crop_report = (crop.to_s + "_report").to_sym
    return crop_report
  end

  def save_input_data
    model = get_form_model(@current_form)
    save_action = get_form_last_action(@current_form)
    model.send save_action, @session
    @session[:dont_perform_input_report_in_request] = true
  end

end