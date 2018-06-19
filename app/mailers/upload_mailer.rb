class UploadMailer < ApplicationMailer

  default from: "info@egranary.co"

  def summary(email, count, errors)
    @count = count
    @errors = errors
    mail(to: email, subject: 'Upload Summary')
  end

  def download_email(email, path)
    @path = path
    mail(to: email, subject: 'eGranary Data Export')
  end

end
