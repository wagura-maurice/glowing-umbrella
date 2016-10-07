###################################################
### Send Batch SMS Messages via async API Calls ###
###################################################

module SendMessages
    extend self

    # Required libraries
    require 'em-http-request'
    require 'AfricasTalkingGateway'

    # Instance variables
    @@api_endpoint = 'https://api.africastalking.com/version1/messaging'
    @@accept_type= 'application/json'
    @@sender_id = "Jiunga"


    def batch_send(to, from='Jiunga', msg)
        #unless Rails.env.development?
            batches = get_batches(to)
            batches.each do |batch|
                recipients = batch.join(',')
                send(recipients, from, msg)
            end
        #end
    end

    def get_batches(arr)
        return arr.each_slice(2000).to_a
    end

    def send(to, from, msg)
        #unless Rails.env.development?
            gateway.send_message(to, msg, from)
        #end
    end

    def send_async(to, from, msg)
        batches = get_batches(to)
        EventMachine.run do
            batches.each do |batch|
                to = batch.join(',')
                http = EventMachine::HttpRequest.new(@@api_endpoint).post(
                    :body => {:username => ENV['SMS_API_ID'], :from => from, :message => msg, :to => to},
                    :head => { 'apiKey' => ENV['SMS_API_KEY'], 'Accept' => @@accept_type}
                )
                p http.req
                http.callback {
                    p http.response_header.status
                    p http.response_header
                    p http.response
                }

                http.errback { p 'Uh oh'; p http.methods; p http.response; p http.state; p http.error; EventMachine.stop }
            end
            sleep(2.0)
            EventMachine.stop
        end
    end

    def gateway
        @gateway ||= AfricasTalkingGateway.new(ENV['SMS_API_ID'], ENV['SMS_API_KEY'])
    end

end
