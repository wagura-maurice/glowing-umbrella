class UserMailer < ActionMailer::Base
  default from: "info@egranary.co"

  def activation_needed_email(user)
    @user = user
    @activation_url  = "https://www.egranary.co/activate/#{@user.activation_token}"
    @login_url  = "app.lipalater.com/login"
    mail(:to => @user.email, :subject => "Welcome to eGranary!")
  end

  def reset_password_email(user)
    @user = user
    @reset_url  = "https://www.egranary.co/reset_password/#{@user.reset_password_token}"
    mail(:to => @user.email, :subject => "Reset your password for eGranary")
  end

end