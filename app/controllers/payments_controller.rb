class PaymentsController < ApplicationController
  require 'securerandom'
  require 'digest'

  skip_before_filter :require_login, :only => [:incoming, :b2c]
  skip_before_filter :verify_authenticity_token

  def incoming
    puts params
    head 200, content_type: "text/html"
  end

  def b2c
    resp = make_b2c_payment(params[:amount], params[:phone_number])
    render json: resp
  end

  def make_b2c_payment(amount, phone_number)
    api_key = '18ac6d1f9d20e285e56021f605a749b8930228528cf1053bbafb5f9350bf9626'

    transID = SecureRandom.hex(6)

    hash = Digest::SHA256.new
    hash.update(transID)
    hash.update(api_key)
    hex = hash.hexdigest

    b2c_params = {
      amount: amount,
      phone: phone_number,
      transID: transID,
      username: 'egranary',
      hash: hex
    }
    resp = RestClient.post 'http://52.49.96.111:8080/admin/send/', b2c_params
    JSON.parse(resp)
    return resp
  end

end
