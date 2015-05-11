class SessionsController < ApplicationController

	skip_before_filter :require_login, :only => [:new, :create, :destroy]

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
	    	@user = User.find_by_phone_number_or_username(params[:phone_number_or_username])
	    	if @user
	    		if @user.activation_state == "active"
	    			add_to_alert("Your username or password was incorrect", "error")
	    			redirect_to :login
	        	else
	        		add_to_alert("Pleave activate your account. We sent you an text message at #{@user.phone_number} with the activation link.", "error")
	        		redirect_to :login
	        	end
	    	else
	        	if params[:phone_number_or_username] == ''
	          		add_to_alert("Please enter a valid phone number or username", "error")
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

	private
  
	def set_user
		@user = login(session_params[:phone_number_or_username], session_params[:password])
	end

	def session_params
		params.permit(:email, :password, :phone_number, :phone_number_or_username, :username)
	end

	def email?(val)

	end
end
