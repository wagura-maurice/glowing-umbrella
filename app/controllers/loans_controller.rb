class LoansController < ApplicationController

  def index
    @loans = Loan.order(:created_at)
    respond_to do |format|
      format.html
      format.csv { send_data @loans.to_csv }
      format.xls {
        # send_data @loans.to_csv(col_sep: "\t")

        EmailExcelDataWorker.perform_async(Loan.to_s, current_user.email, params)
        add_to_alert("Check your email #{current_user.email} in a few minutes with the exported data", "success")
        redirect_to records_table
      }
    end
  end

  def edit
    @loan = Loan.find params[:id]
  end


  def update
    @loan = Loan.find(params[:id])
    to_save = safe_params
    to_save["repaid_date"] = get_datetime(to_save["repaid_date"])
    to_save["disbursed_date"] = get_datetime(to_save["disbursed_date"])
    @loan.update_attributes(to_save)
    add_to_alert("Successfully updated Loan", "success")
    redirect_to :action => :edit
  end


  def destroy
    @loan = Loan.find params[:id]
    @farmer = @loan.farmer
    @loan.destroy
    add_to_alert("Successfully deleted Loan", "info")
    redirect_to edit_farmer_url(@farmer)
  end


  def safe_params
    return params.require(:loan).permit(:commodity,
      :value,
      :time_period,
      :interest_rate,
      :interest_period,
      :interest_type,
      :duration,
      :duration_unit,
      :currency,
      :service_charge,
      :structure,
      :status,
      :disbursed_date,
      :disbursal_method,
      :repaid_date,
      :repayment_method)
    #ret[:disbursed_date] = get_datetime(ret[:disbursed_date])
    #ret[:repaid_date] = get_datetime(ret[:repaid_date])
    #return ret
  end

  # Converts the datetime formatted string given by the bootstrap datetimepicker
  # into a ruby object
  def get_datetime(str)
    return nil if str == ""
    return DateTime.strptime(str, "%d-%m-%Y")
  end

end
