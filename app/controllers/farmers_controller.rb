class FarmersController < ApplicationController

  def edit
    @farmer = Farmer.find(params[:id])
  end

  def index
    @farmers = Farmer.order(:created_at)
    respond_to do |format|
      format.html
      format.csv { send_data @farmers.to_csv }
      format.xls {
        debugger
        send_data @farmers.to_csv(col_sep: "\t")
      }
    end
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


  def safe_params
    return params.require(:farmer).permit(:name, :phone_number, :national_id_number, :association_name, :nearest_town, :county, :country, :year_of_birth, :gender)
  end

end
