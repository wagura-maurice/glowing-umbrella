class Publisher < ActiveRecord::Base
	has_one :user
	has_many :channels
end
