###################################################
### Send Batch SMS Messages via async API Calls ###
###################################################

module SendMessages
  extend self

  # Required libraries
  require 'AfricasTalkingGateway'

  # Instance variables
  @@api_endpoint = 'https://api.africastalking.com/version1/messaging'
  @@accept_type= 'application/json'
  @@sender_id = "eGRANARYKe"


  def batch_send(to, from=@@sender_id, msg)
    # unless Rails.env.development?
      batches = get_batches(to)
      batches.each do |batch|
        add_to_cache(batch.length)
        recipients = batch.join(',')
        send(recipients, from, msg, batch.length)
      end
    # end
  end

  def get_batches(arr)
    return arr.each_slice(2000).to_a
  end

  def send(to, from, msg, count = 1)
    add_to_cache(1)
    unless Rails.env.development?
      resp = gateway.send_message(to, msg, from)
      status = resp[0].status
      if status.downcase == 'success'
        if to.include?(',')
          search_to = to.split(',')
        else
          search_to = [to]
        end
        search_to.each do |num|
          f = Farmer.where(phone_number: num).first
          if f.year_of_birth  >= Time.now.year - 35
            age_demo = 'youth'
          elsif f.year_of_birth  < Time.now.year - 35
            age_demo = 'adult'
          end
          SentMessage.create(
            to: num,
            from: from,
            message: msg,
            num_sent: 1,
            gender: f.gender || 'undefined',
            age_demographic: age_demo || 'undefined',
            country: f.country
          )
        end
      end
      return status
    else
      return 'success'
    end
  end

  def get_sms_cache_key
    return 'sms_' + Time.now.month.to_s + '_' + Time.now.year.to_s
  end

  def add_to_cache(value)
    key = get_sms_cache_key
    if Rails.cache.exist? key
      Rails.cache.increment key, value
    else
      Rails.cache.write key, value
    end
  end

  # def send_async(to, from, msg)
  #   batches = get_batches(to)
  #   EventMachine.run do
  #     batches.each do |batch|
  #       to = batch.join(',')
  #       http = EventMachine::HttpRequest.new(@@api_endpoint).post(
  #         :body => {:username => ENV['SMS_API_ID'], :from => from, :message => msg, :to => to},
  #         :head => { 'apiKey' => ENV['SMS_API_KEY'], 'Accept' => @@accept_type}
  #       )
  #       p http.req
  #       http.callback {
  #         p http.response_header.status
  #         p http.response_header
  #         p http.response
  #       }

  #       http.errback { p 'Uh oh'; p http.methods; p http.response; p http.state; p http.error; EventMachine.stop }
  #     end
  #     sleep(2.0)
  #     EventMachine.stop
  #   end
  # end

  def gateway
    @gateway ||= AfricasTalkingGateway.new(ENV['SMS_API_ID'], ENV['SMS_API_KEY'])
  end

end
