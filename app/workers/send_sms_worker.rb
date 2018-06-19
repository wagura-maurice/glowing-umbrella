class SendSmsWorker
  include Sidekiq::Worker
  sidekiq_options :retry => 1

  def perform(to, from, message)
    i = 0
    status = ''
    while i < 5
      status = SendMessages.send(to, 'eGRANARYKe', message)
      break if status.downcase == 'success'
      i = i + 1
    end
  end

end