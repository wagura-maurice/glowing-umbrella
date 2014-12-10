class Message < ActiveRecord::Base    
	belongs_to :channel

	def self.extract_users(msg)
		return Twitter::Extractor::extract_mentioned_screen_names(msg)
	end

end
