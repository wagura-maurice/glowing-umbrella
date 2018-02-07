class SessionsController < ApplicationController

  skip_before_filter :require_login, :only => [:new, :create, :destroy, :reset_password_form, :post_reset_password_form, :reset_password, :post_reset_password, :activate]

	def new
		if logged_in?
			redirect_back_or_to(:controller => 'dashboard', :action => 'index')
			return
		end
	end

	def create
		if logged_in?
	    	logout
	    end
	    if set_user
  			redirect_back_or_to(:controller => 'dashboard', :action => 'index')
	  	else
	    	@user = User.find_by_email(params[:email])
	    	if @user
	    		if @user.activation_state == "active"
	    			add_to_alert("Your email was incorrect", "error")
	    			redirect_to :login
	        	else
	        		add_to_alert("Please activate your account. We sent you an email with the activation link.", "error")
	        		redirect_to :login
	        	end
	    	else
	        	if params[:email] == ''
	          		add_to_alert("Please enter a valid email", "error")
	          		redirect_to :login
	        	else
	          		add_to_alert("This account doesn't exist. Please contact E-Granary admin to get a valid account", "error")
	          		redirect_to :login
	        	end
	      	end
	  	end
	end

	def destroy
  		logout
  		add_to_alert("Logged out", "success")
    	redirect_to root_url
	end

  def reset_password_form
  end

  def post_reset_password_form
    if logged_in?
      logout
    end
    @user = User.find_by_phone_number_or_email(params["phone_number_or_email"])
    begin
      @user.deliver_reset_password_instructions! if @user
    rescue
      SendNotificationToSlackWorker.perform_async("Someone tried to reset password for #{params['phone_number_or_email']}")
    end
    # Tell the user instructions have been sent whether or not email was found.
    # This is to not leak information to attackers about which emails exist in the system.
    msg = 'Instructions to reset your password have been sent to your email.'
    add_to_alert msg, 'success'
    redirect_to :login
  end

  def reset_password
    if logged_in?
      logout
    end
    @user = User.load_from_reset_password_token(params[:id])
    @token = params[:id]
    redirect_to :login, error: 'The link you tried to access has expired' unless @user
  end

  def post_reset_password
    if logged_in?
      logout
    end
    @token = params[:token]
    @user = User.load_from_reset_password_token(@token)
    not_authenticated and return unless @user
    # the next line makes the password confirmation validation work
    if params[:password] != params[:password_confirmation]
      add_to_alert 'Your passwords do not match. Try again.', 'error'
      redirect_to "/reset_password/#{@token}"
      return
    end
    # the next line clears the temporary token and updates the password
    if @user.change_password!(params[:password])
      add_to_alert 'Password was successfully updated.', 'success'
      redirect_to(:login)
    else
      add_to_alert @user.errors.full_messages.first, 'error'
      redirect_to "/reset_password/#{@token}"
    end
  end

  def activate
    if (@user = User.load_from_activation_token(params[:id]))
      @user.activate!
      add_to_alert "Thanks for activating your account. Log in to start using eGranary!", "success"
      redirect_to :login
    else
      add_to_alert "This account has already been activated. Please log in", "error"
      redirect_to :login
    end
  end

	private

	def set_user
		@user = login(session_params[:email].strip.downcase, session_params[:password])
	end

	def session_params
		params.permit(:email, :password, :email)
	end

end
