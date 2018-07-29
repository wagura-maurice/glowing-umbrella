require 'upload_crop_data'

class UploadCropDataWorker
  include Sidekiq::Worker

  sidekiq_options retry: 0

  def perform(upload_path, email)

    resp = UploadCropData.upload(upload_path)

    # Send email about upload
    UploadMailer.crop_summary(email, resp[:tried], resp[:errors]).deliver_now
  end



end
