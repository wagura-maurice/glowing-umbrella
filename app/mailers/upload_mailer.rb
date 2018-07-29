class UploadMailer < ApplicationMailer

  default from: "info@egranary.co"

  def farmer_summary(email, count, errors)
    @count = count
    @errors = errors
    mail(to: email, subject: 'Farmer Upload Summary')
  end

  def crop_summary(email, count, errors)
    @count = count
    @errors = errors
    mail(to: email, subject: 'Crop Upload Summary')
  end

  def download_email(email, path)
    @path = path
    mail(to: email, subject: 'eGranary Data Export')
  end

end
