class ApiController < ApplicationController
	respond_to :json

	skip_before_filter :verify_authenticity_token, :require_login, :only => [:incoming]

	def incoming
		from = params["From"]
		content = params["Body"]
		sent_to = Message.extract_users(content)
		if sent_to.length != nil
			sent_to.each do |username|
				Message.create(to: username, from: from, content: content, direction: "incoming", read: false, time: Time.now)
			end
		else
			Message.create(from: from, content: content, direction: "incoming", read: false, time: Time.now)
		end
		render :nothing => true, :status => 200, :content_type => 'text/html'
	end

end
