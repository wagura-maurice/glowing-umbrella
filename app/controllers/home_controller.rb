class HomeController < ApplicationController
	skip_before_filter :require_login, :only => [:index]

	def about
	end

	def index
	end

end
