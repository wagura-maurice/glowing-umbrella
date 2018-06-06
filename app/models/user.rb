class User < ActiveRecord::Base
	authenticates_with_sorcery!

	validates_presence_of :email
	validates_uniqueness_of :email

	has_many :farmer_inputs

  def self.search_fields
    return {"email" => {type: :string, key: "Email"}}
  end

  USER_ROLES = {
    'admin' => 'Admin',
    'updater' => 'Updater',
    'mgmt' => 'Management Team',
    'finance' => 'Finance Team',
    'viewer' => 'Viewer'
  }

	def full_name
    return [self.first_name, self.last_name].join(" ")
	end

	before_create :set_country

	def set_country
		self.country = "Kenya"
	end

  def self.find_by_phone_number_or_email(val)
    user = User.find_by_email(val.downcase)
    if user.nil?
      user = User.find_by_phone_number(val)
    end
    return user
  end

  def formatted_role
    return USER_ROLES[self.role]
  end

  def is_admin?
    return self.role == 'admin'
  end

  def is_updater?
    return self.role == 'updater'
  end

  def is_mgmt?
    return self.role == 'mgmt'
  end

  def is_finance?
    return self.role == 'finance'
  end

  def is_viewer?
    return self.role == 'viewer'
  end

end


