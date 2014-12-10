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
    @@api_id = "jiunga" # For AfricasTalking this is the username
    @@api_key = '60c057f2a1734212f30b89d27928b5f4bbaca69439b3f6e4404535146ccbf33e'
    @@sender_id = "Jiunga"


    def send(to, from='Jiunga', msg)
        batches = get_batches(to)
        batches.each do |batch|
            recipients = batch.join(',')
            send_via_africastalking(recipients, from, msg)
        end
    end

    def get_batches(arr)
        return arr.each_slice(2000).to_a
    end

    def send_via_africastalking(to, from, msg)
        gateway.send_message(to, msg, from)
    end

    def send_async(to, from, msg)
        batches = get_batches(to)
        EventMachine.run do
            batches.each do |batch|
                to = batch.join(',')
                http = EventMachine::HttpRequest.new(@@api_endpoint).post(
                    :body => {:username => @@api_id, :from => from, :message => msg, :to => to}, 
                    :head => { 'apiKey' => @@api_key, 'Accept' => @@accept_type}
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
        @gateway ||= AfricasTalkingGateway.new(@@api_id, @@api_key)
    end

end
