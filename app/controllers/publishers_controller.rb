class PublishersController < ApplicationController
	require 'AfricasTalkingGateway'
	require 'send_messages'

	def index
		@inputs = current_user.farmer_inputs
	end

	def blast
		to = current_user.farmer_inputs.pluck(:phone_number).uniq
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
