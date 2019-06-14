class UserMailer < ActionMailer::Base
  default from: "support@e-granary.com"

  def activation_needed_email(user)
    @user = user
    @activation_url  = "https://egranary.herokuapp.com/activate/#{@user.activation_token}"
    @login_url  = "https://egranary.herokuapp.com/login"
    mail(:to => @user.email, :subject => "Welcome to eGranary!")
  end

  def reset_password_email(user)
    @user = user
    @reset_url  = "https://egranary.herokuapp.com/reset_password/#{@user.reset_password_token}"
    mail(:to => @user.email, :subject => "Reset your password for eGranary")
  end

end