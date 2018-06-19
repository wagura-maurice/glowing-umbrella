module UserRegistrationForm

  def user_registration
    {
      start_id: 1,
      questions: {
        1 => {
          question_text: "Welcome to eGranary service. T&C's Apply \nPlease enter your FULL NAME",
          valid_responses: :any_letters,
          save_key: :name,
          next_question: 2,
          error_message: "Please use alphabetical letters only e.g Tim Mwangi. Please enter FULL NAME"
        },
        2 => {
          question_text: "Please enter ID NUMBER",
          valid_responses: :unique_id_number,
          store_validator_function: true,
          save_key: :national_id_number,
          next_question: 3,
          error_message: "The ID Number is not valid or it is already registered. Please enter a new ID NUMBER"
        },
        3 => {
          question_text: "Which farmers organization are you a member of?",
          valid_responses: :any,
          save_key: :association_name,
          next_question: 4,
          error_message: "You're response was not understood. Which Farmers organization are you a member of?"
        },
        4 => {
          question_text: "What is your nearest town?",
          valid_responses: :any_letters,
          save_key: :nearest_town,
          next_question: 5,
          error_message: "Sorry, that answer was not valid. What is your nearest town?"
        },
        5 => {
          question_text: "What county are you in?",
          valid_responses: :any_letters,
          save_key: :county,
          next_question: 6,
          error_message: "Sorry, that answer was not valid. What county are you in?"
        },
        6 => {
          question_text: "In what year were you born? (e.g. 1985)",
          valid_responses: :any_year,
          save_key: :year_of_birth,
          next_question: 7,
          error_message: "Sorry, that answer was not valid. In what year were you born? (e.g. 1985)"
        },
        7 => {
          question_text: "What is your gender? \n1. Male\n2. Female",
          valid_responses: ["1", "2"],
          save_key: :gender,
          next_question: 8,
          error_message: "Sorry, that answer was not valid. What is your gender? \n1. Male\2. Female"
        },
        8 => {
          question_text: "How many acres is your farm?",
          valid_responses: :any_number,
          save_key: :farm_size,
          next_question: 9,
          error_message: "Sorry, that answer was not valid. How many acres is your farm?"
        },
        9 => {
          question_text: "Thank you for registering!",
          valid_responses: nil,
          save_key: nil,
          next_question: nil,
          error_message: nil
        }
      },
      model: Farmer,
      form_last_action: :new_farmer
    }
  end

end