class Api::V1::FarmersController < Api::ApiController

  def show
    phone_number = "254" + params[:phone_number]
    @farmer = Farmer.where(phone_number: phone_number)
    if @farmer?
      render json: la, serializer: Api::V1::FarmerSerializer
    else
      error_msg = "No farmer with this phone number exists"
      render_error_msg(error_msg)
    end
  end

end