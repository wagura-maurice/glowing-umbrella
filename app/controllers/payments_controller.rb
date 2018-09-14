class PaymentsController < ApplicationController

  skip_before_filter :require_login, :only => [:incoming]
  skip_before_filter :verify_authenticity_token

  def incoming
    puts params
    head 200, content_type: "text/html"
  end

end
