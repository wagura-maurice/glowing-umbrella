class Channel < ActiveRecord::Base

	has_many :messages
	has_many :missed_calls
	belongs_to :publisher
	has_and_belongs_to_many :subscribers
	
    before_create :initialize_default_messages

    def initialize_default_messages
        self.subscribe_message = "Sema, vipi? You have been subscribed to the #{self.name} channel, enjoy :) And don't worry, all messages will be free of charge!"
        self.unsubscribe_message = "You have been unsubscribed from the #{self.name} channel."
    end

end
