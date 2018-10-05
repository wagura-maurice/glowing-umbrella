class EgranaryFloatController < ApplicationController

  def dashboard
    @float_transactions = EgranaryFloat.all

    @float_transaction_value = EgranaryFloat.where(txn_type: 'deposit').sum(:value) - EgranaryFloat.where(txn_type: 'withdrawal').sum(:value)
    @loans_disbursed_value = Loan.where.not(disbursed_date: nil).sum(:value)
    @cash_loans_disbursed_value = Loan.where(commodity: 'cash').where.not(disbursed_date: nil).sum(:value)
    @input_loans_disbursed_value = Loan.where(commodity: 'input').where.not(disbursed_date: nil).sum(:value)
    @loans_disbursed_service_charge = Loan.where.not(disbursed_date: nil).sum(:service_charge)
    @loan_repayments = Loan.sum(:amount_paid)

    # Total float value minus all disbursed loans + all loan service charges
    # TODO: Add repayments here
    @total_float = @float_transaction_value - @loans_disbursed_value + @loan_repayments
  end

  def edit
    @txn = EgranaryFloat.find(params[:id])
  end

  def create_float_txn
    @txn = EgranaryFloat.create(
      value: 0.0,
      year: 2018,
      season: $current_season,
      currency: 'KES',
      entry_method: 'egranary portal',
      user: current_user
    )
    redirect_to edit_egranary_float_url(@txn)
  end

  def update
    @txn = EgranaryFloat.find(params[:id])
    to_save = safe_params
    @txn.update_attributes(to_save)
    add_to_alert("Successfully updated Float Account", "success")
    redirect_to :action => :dashboard
  end

  def safe_params
    return params.require(:egranary_float).permit(:value, :txn_type, :notes)
  end

end
