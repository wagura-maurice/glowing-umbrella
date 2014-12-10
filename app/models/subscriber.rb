class Subscriber < ActiveRecord::Base
	has_one :user
	has_many :missed_calls
	has_and_belongs_to_many :channels
end
