class User < ActiveRecord::Base
	authenticates_with_sorcery!

	validates_presence_of :username, :phone_number
	validates_uniqueness_of :phone_number, :username

	belongs_to :publisher
	belongs_to :subscriber
	has_many :farmer_inputs

	#def full_name
    #	return [first_name, last_name].join(" ")
	#end

	before_create :set_country

	def set_country
		self.country = "Kenya"
	end

	def self.find_by_phone_number_or_username(val)
		user = User.find_by_username(val)
		if user.nil?
			user = User.find_by_phone_number(val)
		end
		return user
	end

	

end

		
