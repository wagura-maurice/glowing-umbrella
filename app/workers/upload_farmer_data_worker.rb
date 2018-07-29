require 'upload_farmer_data'

class UploadFarmerDataWorker
  include Sidekiq::Worker

  sidekiq_options retry: 0

  def perform(upload_path, email)

    resp = UploadFarmerData.upload(upload_path)

    # Send email about upload
    UploadMailer.farmer_summary(email, resp[:tried], resp[:errors]).deliver_now
  end



end
