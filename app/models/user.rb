class User < ActiveRecord::Base
	authenticates_with_sorcery!

	validates_presence_of :email
	validates_uniqueness_of :email

	has_many :farmer_inputs

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

end


