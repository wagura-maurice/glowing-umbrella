class PaymentsController < ApplicationController
  require 'securerandom'
  require 'digest'

  skip_before_filter :require_login, :only => [:incoming, :b2c]
  skip_before_filter :verify_authenticity_token

  def incoming
    if params[:account_id].present?
      create_c2b_payment
    end
    puts params
    head 200, content_type: "text/html"
  end

  def b2c
    resp = make_b2c_payment(params[:amount], params[:phone_number])
    render json: resp
  end

  def disburse_loan
    loan = Loan.find params[:id]
    resp = make_b2c_payment(loan.value, loan.farmer.phone_number)
    resp = JSON.parse(resp)
    if resp['status_desc'] == "Transaction successfully accepted"
      loan.disbursed_date = Time.now
      loan.save
      farmer = loan.farmer
      Txn.create(
        value: loan.value,
        account_id: farmer.national_id_number,
        completed_at: Time.now,
        name: farmer.name,
        txn_type: 'b2c',
        phone_number: farmer.phone_number,
        farmer: farmer
      )
    end
    add_to_alert(resp['status_desc'], "info")
    redirect_to edit_farmer_url(loan.farmer)
  end

  def make_b2c_payment(amount, phone_number)
    api_key = '18ac6d1f9d20e285e56021f605a749b8930228528cf1053bbafb5f9350bf9626'

    transID = SecureRandom.hex(6)

    hash = Digest::SHA256.new
    hash.update(transID)
    hash.update(api_key)
    hex = hash.hexdigest

    b2c_params = {
      amount: amount.to_i,
      phone: phone_number,
      transID: transID,
      username: 'egranary',
      hash: hex
    }
    begin
      resp = RestClient.post 'http://52.49.96.111:8080/admin/send/', b2c_params
    rescue => e
      puts e.response
    end
    JSON.parse(resp)
    return resp
  end

  def create_c2b_payment
    # get id, see if it belongs to a farmer
    # if not, then create an orphan payment
    txn = create_payment

    # if it belongs to a farmer, then look at their unpaid loans
    if txn.farmer.present?
      # start with the earliest loan that is unpaid and apply balance to that loan
      farmer = txn.farmer
      txn_balance = txn.value
      farmer.unpaid_loans.each do |loan|
        amount_due = loan.amount_due
        if (amount_due >= txn_balance)
          apply_balance_to_loan(txn_balance, loan, txn)
          break
        elsif (amount_due < txn_balance)
          apply_balance_to_loan(amount_due, loan, txn)
          txn_balance = txn_balance - amount_due
        end
      end
    end
  end

  def apply_balance_to_loan(balance, loan, txn)
    loan.amount_paid = loan.amount_paid + balance
    if loan.amount_due <= loan.amount_paid
      loan.status = 'fully paid'
      loan.repaid_date = Time.now
    end
    loan.save
    LoansTxns.create(loan: loan, txn: txn, amount_paid: balance)
  end

  def create_payment
    f = Farmer.where(national_id_number: params[:account_id]).first
    Txn.create(
      value: params[:amount].to_f,
      account_id: params[:account_id],
      completed_at: params[:completed_at],
      phone_number: params[:phone],
      name: params[:names],
      txn_type: 'c2b',
      farmer: f
    )
  end

end
