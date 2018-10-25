class DashboardController < ApplicationController
  require 'AfricasTalkingGateway'
  require 'send_messages'

  include ModelSearch

  before_action :set_route_name

  def index
    # Get Statistics to display in the view

    # Number of farmers
    @total_farmers = Farmer.count
    @total_pending_farmers = Farmer.where(status: 0).count
    @total_verified_farmers = Farmer.where(status: 1).count

    # Number of farmers by crop type
    @maize_farmers_count = MaizeReport.pluck(:farmer_id).uniq.length
    @rice_farmers_count =  RiceReport.pluck(:farmer_id).uniq.length
    @bean_farmers_count = BeansReport.pluck(:farmer_id).uniq.length
    @green_gram_farmers_count = GreenGramsReport.pluck(:farmer_id).uniq.length
    @black_eyed_bean_farmers_count = BlackEyedBeansReport.pluck(:farmer_id).uniq.length
    # @nerica_rice_farmers_count = NericaRiceReport.pluck(:farmer_id).uniq.length
    @soya_bean_farmers_count = SoyaBeansReport.pluck(:farmer_id).uniq.length
    @pigeon_peas_farmers_count = PigeonPeasReport.pluck(:farmer_id).uniq.length

    # Crop statistics
    @total_maize_bags_harvested = MaizeReport.sum :bags_harvested
    @total_rice_bags_harvested = RiceReport.sum :bags_harvested
    @total_bean_bags_harvested = BeansReport.sum :bags_harvested
    @total_green_gram_bags_harvested = GreenGramsReport.sum :bags_harvested
    @total_black_eyed_bean_bags_harvested = BlackEyedBeansReport.sum :bags_harvested
    # @total_nerica_rice_bags_harvested = NericaRiceReport.sum :bags_harvested
    @total_soya_bean_bags_harvested = SoyaBeansReport.sum :bags_harvested
    @total_pigeon_pea_bags_harvested = PigeonPeasReport.sum :bags_harvested

    @total_maize_planted = MaizeReport.sum :kg_of_seed_planted
    @total_rice_planted = RiceReport.sum :kg_of_seed_planted
    @total_bean_planted = BeansReport.sum :kg_of_seed_planted
    @total_green_gram_planted = GreenGramsReport.sum :kg_of_seed_planted
    @total_black_eyed_bean_planted = BlackEyedBeansReport.sum :kg_of_seed_planted
    # @total_nerica_rice_planted = NericaRiceReport.sum :kg_of_seed_planted
    @total_soya_bean_planted = SoyaBeansReport.sum :kg_of_seed_planted
    @total_pigeon_pea_planted = PigeonPeasReport.sum :kg_of_seed_planted

  end

  def loans_summary
    @total_loans = Loan.count
    @total_loan_amount = Loan.sum :value
    @avg_loan_amount = Loan.average :value
    @avg_interest_rate = Loan.average :interest_rate
    @total_repayments = Txn.where(txn_type: 'c2b').sum(:value)
    repayments = Loan.all.map { |loan| loan.amount_paid / loan.amount_due }
    @avg_loan_repayment_rate = ((repayments.sum / repayments.count) * 100).round(2)
  end

  def ageing_reports
    ret = AgeingReportDatatable.new(view_context)
    respond_to do |format|
      format.html
      format.json { render json: ret }
    end
  end

  def farmers_table
    @search_fields = Farmer.search_fields
    @datatable_search_params = datatable_search_params(@search_fields)
    @loan = Loan.new
    ret = FarmerDatatable.new(view_context)
    respond_to do |format|
      format.html
      format.json { render json: ret }
    end
  end

  def assign_loans
    records = run_queries(Farmer, params)
    records.each do |farmer|
      farmer.received_loans = true
      farmer.save
      loan = Loan.new(loan_params)
      loan.farmer = farmer
      loan.save
      msg = "You have been issued a new loan from eGranary. Please log in to eGranary to see your loan details"
      SendSmsWorker.perform_async(farmer.phone_number, 'eGRANARYKe', msg)
    end
    redirect_to :farmers_table
  end

  def farmer_groups_table
    @search_fields = FarmerGroup.search_fields
    @datatable_search_params = datatable_search_params(@search_fields)
    ret = FarmerGroupDatatable.new(view_context)
    respond_to do |format|
      format.html
      format.json { render json: ret }
    end
  end

  def loans_table
    @total_loans = Loan.count
    @total_loan_amount = Loan.sum :value
    @avg_loan_amount = Loan.average :value
    @avg_interest_rate = Loan.average :interest_rate
    @total_repayments = Txn.where(txn_type: 'c2b').sum(:value)
    repayments = Loan.all.map { |loan| loan.amount_paid / loan.amount_due }
    @avg_loan_repayment_rate = ((repayments.sum / repayments.count) * 100).round(2)

    @search_fields = Loan.search_fields
    @datatable_search_params = datatable_search_params(@search_fields)
    ret = LoanDatatable.new(view_context)
    respond_to do |format|
      format.html
      format.json { render json: ret }
    end
  end

  def payments_table
    @search_fields = Txn.search_fields
    @datatable_search_params = datatable_search_params(@search_fields)
    ret = TxnDatatable.new(view_context)
    respond_to do |format|
      format.html
      format.json { render json: ret }
    end
  end

  def users_table
    @search_fields = Loan.search_fields
    @datatable_search_params = datatable_search_params(@search_fields)
    ret = UserDatatable.new(view_context)
    respond_to do |format|
      format.html
      format.json { render json: ret }
    end
  end

  def maize_reports_table
    @search_fields = MaizeReport.search_fields
    @datatable_search_params = datatable_search_params(@search_fields)
    ret = MaizeReportDatatable.new(view_context)
    respond_to do |format|
      format.html
      format.json { render json: ret }
    end
  end

  def rice_reports_table
    @search_fields = RiceReport.search_fields
    @datatable_search_params = datatable_search_params(@search_fields)
    ret = RiceReportDatatable.new(view_context)
    respond_to do |format|
      format.html
      format.json { render json: ret }
    end
  end

  def nerica_rice_reports_table
    @search_fields = NericaRiceReport.search_fields
    @datatable_search_params = datatable_search_params(@search_fields)
    ret = NericaRiceReportsDatatable.new(view_context)
    respond_to do |format|
      format.html
      format.json { render json: ret }
    end
  end

  def beans_reports_table
    @search_fields = BeansReport.search_fields
    @datatable_search_params = datatable_search_params(@search_fields)
    ret = BeansReportDatatable.new(view_context)
    respond_to do |format|
      format.html
      format.json { render json: ret }
    end
  end

  def green_grams_reports_table
    @search_fields = GreenGramsReport.search_fields
    @datatable_search_params = datatable_search_params(@search_fields)
    ret = GreenGramsReportDatatable.new(view_context)
    respond_to do |format|
      format.html
      format.json { render json: ret }
    end
  end

  def black_eyed_beans_reports_table
    @search_fields = BlackEyedBeansReport.search_fields
    @datatable_search_params = datatable_search_params(@search_fields)
    ret = BlackEyedBeansReportDatatable.new(view_context)
    respond_to do |format|
      format.html
      format.json { render json: ret }
    end
  end

  def soya_beans_reports_table
    @search_fields = SoyaBeansReport.search_fields
    @datatable_search_params = datatable_search_params(@search_fields)
    ret = SoyaBeansReportDatatable.new(view_context)
    respond_to do |format|
      format.html
      format.json { render json: ret }
    end
  end

  def pigeon_peas_reports_table
    @search_fields = PigeonPeasReport.search_fields
    @datatable_search_params = datatable_search_params(@search_fields)
    ret = PigeonPeasReportDatatable.new(view_context)
    respond_to do |format|
      format.html
      format.json { render json: ret }
    end
  end

  def send_sms
    @search_fields = Farmer.search_fields
    @datatable_search_params = datatable_search_params(@search_fields)
    records = run_queries(Farmer, params)
    @farmer_count = records.count
  end

  def base_query
    Farmer.all
  end

  def post_send_sms
    records = run_queries(Farmer, params)
    to = records.map(&:phone_number)
    unless Rails.env.development?
      SendMessages.batch_send(to, 'eGRANARYKe', params["message"])
    end
    add_to_alert("Successfully sent SMS", "success")
    redirect_to :controller => :dashboard, :action => :send_sms
  end

  def blast
    if params["send_messages_to"] == "1"
      to = Farmer.pluck(:phone_number).uniq.compact
    elsif params["send_messages_to"] == "2"
      ids = MaizeReport.pluck(:farmer_id).uniq.compact
      to = Farmer.find(ids).map(&:phone_number)
    elsif params["send_messages_to"] == "3"
      ids = RiceReport.pluck(:farmer_id).uniq.compact
      to = Farmer.find(ids).map(&:phone_number)
    elsif params["send_messages_to"] == "4"
      ids = BeansReport.pluck(:farmer_id).uniq.compact
      to = Farmer.find(ids).map(&:phone_number)
    elsif params["send_messages_to"] == "5"
      ids = GreenGramsReport.pluck(:farmer_id).uniq.compact
      to = Farmer.find(ids).map(&:phone_number)
    elsif params["send_messages_to"] == "6"
      ids = BlackEyedBeansReport.pluck(:farmer_id).uniq.compact
      to = Farmer.find(ids).map(&:phone_number)
    elsif params["send_messages_to"] == "7"
      ids = SoyaBeansReport.pluck(:farmer_id).uniq.compact
      to = Farmer.find(ids).map(&:phone_number)
    elsif params["send_messages_to"] == "8"
      ids = PigeonPeasReport.pluck(:farmer_id).uniq.compact
      to = Farmer.find(ids).map(&:phone_number)
    end
    unless Rails.env.development?
      SendMessages.batch_send(to, 'eGRANARYKe', params["message"])
    end
    redirect_to :controller => :dashboard, :action => :index
  end

  def loan_params
    return params.require(:loan).permit(:commodity,
      :value,
      :time_period,
      :interest_rate,
      :interest_period,
      :interest_type,
      :duration,
      :duration_unit,
      :currency,
      :service_charge_percentage,
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

  private

  def set_route_name
    @route_name =  '/' + params[:action]
  end

end
