class DashboardController < ApplicationController
  require 'AfricasTalkingGateway'
  require 'send_messages'

  include ModelSearch

  before_action :set_route_name

  def index
    # Get Statistics to display in the view

    # Number of farmers
    @total_farmers = Farmer.count
    @total_pending_farmers = Farmer.where(status: 'pending').count
    @total_verified_farmers = Farmer.where(status: 'verified').count

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

  def dashboard_home
    @dashboard_view = true
    @dashboard_home = true

    @total_farmers = Farmer.count
    @total_pending_farmers = Farmer.where(status: 'pending').count
    @total_verified_farmers = Farmer.where(status: 'verified').count
    @total_acreage = Farmer.sum(:farm_size)
    @total_farmer_groups = FarmerGroup.count

    @total_maize_planted = MaizeReport.sum :kg_of_seed_planted
    @total_rice_planted = RiceReport.sum :kg_of_seed_planted
    @total_bean_planted = BeansReport.sum :kg_of_seed_planted
    @total_green_gram_planted = GreenGramsReport.sum :kg_of_seed_planted
    @total_black_eyed_bean_planted = BlackEyedBeansReport.sum :kg_of_seed_planted
    @total_soya_bean_planted = SoyaBeansReport.sum :kg_of_seed_planted
    @total_pigeon_pea_planted = PigeonPeasReport.sum :kg_of_seed_planted
    @total_kgs_planted = @total_maize_planted + @total_rice_planted + @total_bean_planted + @total_green_gram_planted + @total_black_eyed_bean_planted + @total_soya_bean_planted + @total_pigeon_pea_planted

    @total_maize_harvested = MaizeReport.sum :bags_harvested
    @total_rice_harvested = RiceReport.sum :bags_harvested
    @total_bean_harvested = BeansReport.sum :bags_harvested
    @total_green_gram_harvested = GreenGramsReport.sum :bags_harvested
    @total_black_eyed_bean_harvested = BlackEyedBeansReport.sum :bags_harvested
    @total_soya_bean_harvested = SoyaBeansReport.sum :bags_harvested
    @total_pigeon_pea_harvested = PigeonPeasReport.sum :bags_harvested
    @total_bags_harvested = @total_maize_harvested + @total_rice_harvested + @total_bean_harvested + @total_green_gram_harvested + @total_black_eyed_bean_harvested + @total_soya_bean_harvested + @total_pigeon_pea_harvested

    @total_loans = Loan.count
    @total_loan_amount = Loan.sum :value
    repayments = Loan.all.map { |loan| loan.amount_paid / loan.amount_due }
    @avg_loan_repayment_rate = ((repayments.sum / repayments.count) * 100).round(2)

    @total_male = Farmer.where(gender: 'male').count
    @total_female = Farmer.where(gender: 'female').count
    @total_youth = Farmer.where('year_of_birth >= ?', Time.now.year - 35).count

    @active_farmers = Farmer.where(received_loans: true).count

    group_names = FarmerGroup.order(:county).pluck(:short_names, :formal_name, :county)
    @farmers_by_group = {}
    @farmers_by_county = {}
    group_names.each do |name_arr|
      formal_name = name_arr[1]
      name = name_arr[0]
      county = name_arr[2]
      @farmers_by_group[formal_name] = Farmer.where("association_name ILIKE ?", "%#{name}%").count
      if @farmers_by_county[county].present?
        @farmers_by_county[county][:num_farmers] += @farmers_by_group[formal_name]
        @farmers_by_county[county][:num_groups] += 1
      else
        @farmers_by_county[county] = {num_groups: 1, num_farmers: @farmers_by_group[formal_name] }
      end
    end

    @total_repayments = Txn.where(txn_type: 'c2b').sum(:value)
    @total_borrowers = Loan.distinct.count('farmer_id')
    @total_loan_amount = Loan.sum :value
  end

  def dashboard_farmers
    @dashboard_view = true
    @dashboard_farmers = true
  end

  def dashboard_argonomy
    @dashboard_view = true
    @dashboard_argonomy = true
  end

  def dashboard_farmer_groups
    @dashboard_view = true
    @dashboard_farmer_groups = true
  end

  def dashboard_communications
    @dashboard_view = true
    @dashboard_communications = true
  end

  def dashboard_loans
    @dashboard_view = true
    @dashboard_loans = true
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
    ret = FarmerDatatable.new(view_context)
    respond_to do |format|
      format.html
      format.json { render json: ret }
    end
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
    # unless Rails.env.development?
      SendMessages.batch_send(to, 'eGRANARYKe', params["message"])
    # end
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


  private

  def set_route_name
    @route_name =  '/' + params[:action]
  end

end
