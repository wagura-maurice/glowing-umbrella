class UsersController < ApplicationController
	skip_before_filter :require_login, :only => [:new, :create]

	def new
		@user = User.new
	end

	def create
		@user = User.create(user_params)
		if @user
			if @user.errors.size != 0
				put_messages_in_flash
				redirect_to :action => :new
				return
			else
				@user.activate!
				set_user
				redirect_to :controller => :publishers, :action => :index
				return
			end
		else
			redirect_to :action => :new
			return
		end
	end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update_attributes(safe_params)
    add_to_alert("Successfully updated User", "success")
    redirect_to :action => :edit
  end

  def invite
    @user = User.new
  end

  def post_invite
    @user = User.create(create_params)
    if @user.valid?
      add_to_alert("Successfully invited User", "success")
      # UserMailer.activation_needed_email(@user).deliver_now
    else
      add_to_alert("Invalid user info", "error")
    end
    redirect_to :controller => :dashboard, :action => :users_table
  end

	protected
	def user_params
		params.require(:user).permit(:email, :password)
	end

	def set_user
		@user = login(user_params[:email], user_params[:password])
	end

	def put_messages_in_flash
		if @user.errors.size > 0
			if !flash[:notice]
				flash[:notice] = Hash.new
				flash[:notice][:error] = Array.new
			elsif !flash[:notice][:error]
				flash[:notice][:error]
			end
			@user.errors.full_messages.each do |msg|
				flash[:notice][:error] << msg
			end
		end
	end

  def safe_params
    return params.require(:user).permit(:first_name, :last_name, :phone_number, :role, :activation_state)
  end

  def create_params
    return params.require(:user).permit(:email, :first_name, :last_name, :phone_number, :role, :activation_state)
  end

end
