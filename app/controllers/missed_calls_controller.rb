class MissedCallsController < ApplicationController
	skip_before_filter :verify_authenticity_token
	skip_before_filter :require_login, :only => [:incoming]

	require 'send_messages'

	# Will subscribe a phone number to a channel or unsubscribe them as well
	def incoming

		# This function handles the call endpoint for the AfricasTalking voice API
		# Assumes that the AfricasTalking parameters of 'destinationNumber' and
		# 'callerNumber' are present.

		# Required variables
		dest_num = params["destinationNumber"]
		caller_num = params["callerNumber"]
#
#		# If miss call isn't recent
#		if !Rails.cache.read(generate_cache_key(caller_num, dest_num))
#			Rails.cache.write(generate_cache_key(caller_num, dest_num), true, :expires_in => 60*10)
#			action = nil
#			if dest_num.present? && caller_num.present?
#				channel = Channel.where(phone_number: dest_num).first
#				subscriber = Subscriber.where(phone_number: caller_num).first_or_create
#				subscribe = !(channel.subscribers.exists? subscriber)
#				if subscribe
#					channel.subscribers << subscriber
#					send_welcome_message(caller_num, channel.name)
#					action = 'subscribed'
#				else
#					channel.subscribers.delete subscriber
#					send_unsubscribe_message(caller_num, channel.name)
#					action = 'unsubscribed'
#				end
#			end
#			# Store miss call record
#			MissedCall.create(time: Time.now, from: caller_num, to: dest_num, channel: channel, subscriber: subscriber, action: action)
#		end

		# Reponds to Voice API
		if !Rails.cache.read(generate_cache_key(caller_num, dest_num))
			Rails.cache.write(generate_cache_key(caller_num, dest_num), true, :expires_in => 15)
			#to_send = {query: {phone_number: caller_num, time: Time.now.to_i}}
			#base_uri = 'http://www.bambarewards.com/ssscripts/flashscribe/callReceived.php'
			#HTTParty.get(base_uri, to_send)
		end
		empty = {'Reject' => ''}
    	render :xml => empty.to_xml(root: 'Response')
	end

	private

	def send_welcome_message(to, channel_name)
		msg = "Sema, vipi? You have been subscribed to the #{channel_name} channel, enjoy :) And don't worry, all messages will be free of charge!"
		SendMessages.send([to], 'Jiunga', msg)
	end

	def send_unsubscribe_message(to, channel_name)
		msg = "You have been unsubscribed from the #{channel_name} channel."
		SendMessages.send([to], 'Jiunga', msg)
	end

	def generate_cache_key(caller_num, dest_num)
		return ['missed_call', 'to:'+caller_num, 'from:'+dest_num]
	end

end
