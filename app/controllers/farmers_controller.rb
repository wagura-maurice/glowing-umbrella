class FarmersController < ApplicationController

  include ModelSearch

  def edit
    @farmer = Farmer.find(params[:id])
    @loan_count = @farmer.loans.count
  end

  def index
    @farmers = Farmer.order(:created_at)
    respond_to do |format|
      format.html
      format.csv { send_data @farmers.to_csv }
      format.xls do
        # records = run_queries(Farmer, params)
        # send_data records.to_csv(col_sep: "\t")

        EmailExcelDataWorker.perform_async(Farmer.to_s, current_user.email, params)
        add_to_alert("Check your email #{current_user.email} in a few minutes with the exported data", "success")
        redirect_to :farmers_table
      end
    end
  end

  def base_query
    Farmer
  end
#
#  def show
#    debugger
#    puts "yo"
#  end
#
#  def create
#    debugger
#    puts "yo"
#  end

  def update
    @farmer = Farmer.find(params[:id])
    @farmer.update_attributes(safe_params)
    add_to_alert("Successfully updated Farmer", "success")
    redirect_to :action => :edit
  end

  def destroy
    @farmer = Farmer.find(params[:id])
    @farmer.destroy
    add_to_alert("Successfully deleted Farmer", "info")
    redirect_to :farmers_table
  end


  def create_loan
    @farmer = Farmer.find(params[:id])
    @loan = Loan.create(farmer: @farmer)
    redirect_to edit_loan_url(@loan)
  end

  def upload_button
    upload_path = 'farmer_uploads/' + SecureRandom.uuid
    @s3_direct_post = AwsAdapter.get_s3_direct_post(upload_path)
  end

  def upload_data
    UploadFarmerDataWorker.perform_async(params[:upload_path], current_user.email)
    add_to_alert("Uploading data. You will receive a status update at #{current_user.email} shortly.", "info")
    redirect_to :app
  end

  def safe_params
    return params.require(:farmer).permit(:name, :phone_number, :national_id_number, :association_name, :nearest_town, :county, :country, :year_of_birth, :gender, :received_loans, :status, :farm_size)
  end

end
