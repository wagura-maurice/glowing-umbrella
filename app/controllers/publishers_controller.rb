class PublishersController < ApplicationController
	require 'AfricasTalkingGateway'
	require 'send_messages'

	def index
		publisher = current_user.publisher
		return if publisher.nil?
		@channel = publisher.channels.first

		if @channel && @channel.messages.length > 0
			#@messages = @channel.messages
		end
	end

	def blast
		publisher = current_user.publisher
		@channel = publisher.channels.first

		#@channel.subscribers.each do |subscriber|
			#Message.create(channel: @channel, direction: "outgoing", to: subscriber.phone_number, from: publisher.user.phone_number, content: message_content["message"], time: Time.now)
			#send_message(subscriber.phone_number, params["message"])
		#end
		to = @channel.subscribers.pluck(:phone_number)
		SendMessages.send(to, 'Jiunga', params["message"])
		redirect_to :controller => :publishers, :action => :index
	end


	protected
	def message_content
		params.permit(:message)
	end

	def send_message(to, msg)
		username = "jiunga"
		apikey = '60c057f2a1734212f30b89d27928b5f4bbaca69439b3f6e4404535146ccbf33e'
		gateway = AfricasTalkingGateway.new(username, apikey)
		reports = gateway.send_message(to, msg)
	end

end
