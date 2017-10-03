class Api::V1::FarmersController < Api::ApiController

  def show
    phone_number = "+" + params[:phone_number]
    @farmer = Farmer.where(phone_number: phone_number).first
    if @farmer
      render json: @farmer, farmer_reports: get_reports(@farmer.id), serializer: Api::V1::FarmerSerializer
    else
      error_msg = "No farmer with this phone number exists"
      render_error_msg(error_msg)
    end
  end


  def get_reports(farmer_id)
    reports = []

    CROPS.each do |k, v|
      model = v[:model]
      crop_reports = model.unscoped.where(farmer_id: farmer_id).to_ary
      reports += crop_reports
    end

    return reports.sort_by { |report| report.created_at }
  end

end