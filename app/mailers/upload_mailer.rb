class UploadMailer < ApplicationMailer

  default from: "info@egranary.co"

  def summary(email, count, errors)
    @count = count
    @errors = errors
    mail(to: email, subject: 'Upload Summary')
  end

end
