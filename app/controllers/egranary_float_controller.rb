class EgranaryFloatController < ApplicationController

  def dashboard
    @float_transactions = EgranaryFloat.all

    @float_transaction_value = EgranaryFloat.sum(:value)
    @loans_disbursed_value = Loan.where.not(disbursed_date: nil).sum(:value)
    @loans_disbursed_service_charge = Loan.where.not(disbursed_date: nil).sum(:service_charge)

    # Total float value minus all disbursed loans + all loan service charges
    # TODO: Add repayments here
    @total_float = @float_transaction_value - @loans_disbursed_value + @loans_disbursed_service_charge
  end

end
