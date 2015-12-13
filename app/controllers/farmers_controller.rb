class FarmersController < ApplicationController

  def edit
    @farmer = Farmer.find(params[:id])
  end

#  def index
#    debugger
#    puts "yo"
#  end
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
    redirect_to :action => :edit
  end

  def destroy
    @farmer = Farmer.find(params[:id])
    @farmer.destroy
    redirect_to :farmers_table
  end


  def safe_params
    return params.require(:farmer).permit(:name, :phone_number, :national_id_number, :association_name, :nearest_town, :county, :country, :year_of_birth, :gender)
  end

end
