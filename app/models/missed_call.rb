class MissedCall < ActiveRecord::Base

	belongs_to :channel
	belongs_to :subscriber
	
end
