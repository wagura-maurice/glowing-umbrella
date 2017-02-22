class PaymentsController < ApplicationController

  skip_before_filter :require_login, :only => [:customer_payment]
  skip_before_filter :verify_authenticity_token

  def customer_payment
    puts params
    head 200, content_type: "text/html"
  end

end
