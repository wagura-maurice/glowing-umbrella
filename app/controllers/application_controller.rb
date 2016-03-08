class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

	before_filter :require_login, :except => [:not_authenticated]

	def datatable_search_params(search_fields)
		ret = {format: :json}
		if search_fields.present?
			search_fields.each do |k, v|
				if v[:type] == :time || v[:type] == :number
					ret[k + "__gt"] = params[k + "__gt"]
					ret[k + "__lt"] = params[k + "__lt"]
					ret[k + "__eq"] = params[k + "__eq"]
				elsif v[:type] == :string
					ret[k + "__eq"] = params[k + "__eq"]
				elsif v[:type] == :select
					ret[k + "__eq"] = params[k + "__eq"]
				end
			end
		end
		return ret
	end

	protected

    def not_authenticated
      redirect_to login_path, :alert => "Login required."
    end

    def add_to_alert(message, type="error")
		if !flash[:notice]
			flash[:notice] = Hash.new
		end
		case type
		when "error"
			if flash[:notice][:error]
				flash[:notice][:error] << message
			else
				flash[:notice][:error] = Array.new
				flash[:notice][:error] << message
			end
		when "info"
			if flash[:notice][:info]
				flash[:notice][:info] << message
			else
				flash[:notice][:info] = Array.new
				flash[:notice][:info] << message
			end
		when "success"
			if flash[:notice][:success]
				flash[:notice][:success] << message
			else
				flash[:notice][:success] = Array.new
				flash[:notice][:success] << message
			end
		when "warning"
			if flash[:notice][:warning]
				flash[:notice][:warning] << message
			else
				flash[:notice][:warning] = Array.new
				flash[:notice][:warning] << message
			end
		end
	end

end
