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

    @total_sms_sent_this_month = SentMessage.where('created_at > ?', Date.today.at_beginning_of_month).sum(:num_sent)
  end

  def dashboard_farmers
    @dashboard_view = true
    @dashboard_farmers = true
    @total_youth = Farmer.where('year_of_birth >= ?', Time.now.year - 35).count
    @total_adult = Farmer.where('year_of_birth < ?', Time.now.year - 35).count
    @age_range = {'Youth' => @total_youth, 'Adult' => @total_adult}

    @below_25_f = Farmer.where('year_of_birth > ?', Time.now.year - 25).where(gender: 'female').count
    @between_25_and_35_f = Farmer.where('year_of_birth < ? AND year_of_birth >= ?', Time.now.year - 25, Time.now.year - 35).where(gender: 'female').count
    @between_35_and_45_f = Farmer.where('year_of_birth < ? AND year_of_birth >= ?', Time.now.year - 35, Time.now.year - 45).where(gender: 'female').count
    @between_45_and_55_f = Farmer.where('year_of_birth < ? AND year_of_birth >= ?', Time.now.year - 45, Time.now.year - 55).where(gender: 'female').count
    @above_55_f = Farmer.where('year_of_birth < ?', Time.now.year - 55).where(gender: 'female').count

    @below_25_m = Farmer.where('year_of_birth > ?', Time.now.year - 25).where(gender: 'male').count
    @between_25_and_35_m = Farmer.where('year_of_birth < ? AND year_of_birth >= ?', Time.now.year - 25, Time.now.year - 35).where(gender: 'male').count
    @between_35_and_45_m = Farmer.where('year_of_birth < ? AND year_of_birth >= ?', Time.now.year - 35, Time.now.year - 45).where(gender: 'male').count
    @between_45_and_55_m = Farmer.where('year_of_birth < ? AND year_of_birth >= ?', Time.now.year - 45, Time.now.year - 55).where(gender: 'male').count
    @above_55_m = Farmer.where('year_of_birth < ?', Time.now.year - 55).where(gender: 'male').count
  end

  def farmer_data_by_country
    country = params['country']
    fgs = FarmerGroup.where("country ILIKE ?", "%#{country}%")
    ret = {}
    fgs.each do |group|
      name = group.short_names.split('|')[0]
      ret[group.formal_name] = {
        male: Farmer.where("association_name ILIKE ?", "%#{name}%").where(gender: 'male').count,
        female: Farmer.where("association_name ILIKE ?", "%#{name}%").where(gender: 'female').count,
        youth: Farmer.where("association_name ILIKE ?", "%#{name}%").where('year_of_birth >= ?', Time.now.year - 35).count,
        adult: Farmer.where("association_name ILIKE ?", "%#{name}%").where('year_of_birth < ?', Time.now.year - 35).count,
        total: Farmer.where("association_name ILIKE ?", "%#{name}%").count
      }
    end

    respond_to do |format|
      format.json { render json: ret }
    end
  end

  def farmer_data_per_crop_by_country
    country = params['country']
    crop = params['crop']
    model = CROPS[crop.to_sym][:model]
    fgs = FarmerGroup.where("country ILIKE ?", "%#{country}%")
    ret = {}
    fgs.each do |group|
      name = group.short_names.split('|')[0]
      farmer_ids = Farmer.where("association_name ILIKE ?", "%#{name}%").pluck(:id)
      ret[group.formal_name] = {
        kg_seed_planted: model.unscoped.where(report_type: 'planting').where(farmer_id: farmer_ids).sum(:kg_of_seed_planted),
        total_bags_harvested: model.unscoped.where(report_type: 'harvest').where(farmer_id: farmer_ids).sum(:bags_harvested),
        aggregated_produce: group.aggregated_harvest_data,
        produce_collected: group.total_harvest_collected_for_sale
      }
    end
    respond_to do |format|
      format.json { render json: ret }
    end
  end

  def dashboard_argonomy
    @dashboard_view = true
    @dashboard_argonomy = true

    @maize_farmers_count = MaizeReport.unscoped.distinct(:farmer_id).count
    @rice_farmers_count =  RiceReport.unscoped.distinct(:farmer_id).count
    @bean_farmers_count = BeansReport.unscoped.distinct(:farmer_id).count
    @green_gram_farmers_count = GreenGramsReport.unscoped.distinct(:farmer_id).count
    @black_eyed_bean_farmers_count = BlackEyedBeansReport.unscoped.distinct(:farmer_id).count
    @soya_bean_farmers_count = SoyaBeansReport.unscoped.distinct(:farmer_id).count
    @pigeon_peas_farmers_count = PigeonPeasReport.unscoped.distinct(:farmer_id).count

    @total_repayments = Txn.where(txn_type: 'c2b').sum(:value)

    @country = params['country']
    if (@country.present?) && (@country != '-')
      @show_tables = true
      CROPS.each do |k, v|
        crop_name = v[:text]
        model = v[:model]

        base = model.unscoped.joins(:farmer).where('farmers.country ILIKE ?', "%#{@country}%")
        model_to_s = model.to_s.underscore.pluralize
        males = base.where('farmers.gender = ?', 'male').count
        females = base.where('farmers.gender = ?', 'female').count
        youth = base.where('farmers.year_of_birth >= ?', Time.now.year - 35).count
        adult = base.where('farmers.year_of_birth < ?', Time.now.year - 35).count
        self.instance_variable_set("@#{k.to_s}_male", males)
        self.instance_variable_set("@#{k.to_s}_female", females)
        self.instance_variable_set("@#{k.to_s}_youth", youth)
        self.instance_variable_set("@#{k.to_s}_adult", adult)
      end
    end

    @crop = params[:crop_for_farmers]
    if (@crop.present?) && (@crop != '-')
      @show_crop_analysis = true
      @crop = @crop.to_sym

      crop_data = CROPS[@crop]
      @crop_name = crop_data[:text]
      base = crop_data[:model].unscoped

      if params[:date_greater_than].present?
        base = base.where('created_at > ?', params[:date_greater_than])
      end
      if params[:date_less_than].present?
        base = base.where('created_at < ?', params[:date_less_than])
      end
      @kg_seed_planted = base.sum(:kg_of_seed_planted)
      @kg_fertilizer = base.sum(:kg_of_fertilizer)
      @bags_harvested = base.sum(:bags_harvested)

    end
  end

  def planting_harvesting_data_by_country
    country = params['country']
    ret = {}
    CROPS.each do |k, v|
      crop_name = v[:text]
      model = v[:model]

      base = model.unscoped.joins(:farmer).where('farmers.country ILIKE ?', "%#{country}%")
      model_to_s = model.to_s.underscore.pluralize
      kg_seed_planted = base.sum("#{model_to_s}.kg_of_seed_planted")
      bags_harvested = base.sum("#{model_to_s}.bags_harvested")
      farmer_count = model.unscoped.distinct(:farmer_id).count

      ret[crop_name] = {
        kg_seed_planted: kg_seed_planted,
        bags_harvested: bags_harvested,
        farmer_count: farmer_count
      }
    end

    respond_to do |format|
      format.json { render json: ret }
    end
  end

  def dashboard_farmer_groups
    @dashboard_view = true
    @dashboard_farmer_groups = true
  end

  def dashboard_communications
    @dashboard_view = true
    @dashboard_communications = true

    @total_sms_sent_this_month = SentMessage.where('created_at > ?', Date.today.at_beginning_of_month).sum(:num_sent)
    @total_sms_sent_this_week = SentMessage.where('created_at > ?', Date.today.at_beginning_of_week).sum(:num_sent)
    @total_sms_sent_today = SentMessage.where('created_at > ?', Date.today).sum(:num_sent)
    @total_sms_sent_last_month = SentMessage.where('created_at > ? AND created_at < ?', Date.today.prev_month.beginning_of_month, Date.today.at_beginning_of_month).sum(:num_sent)
  end

  def dashboard_loans
    @dashboard_view = true
    @dashboard_loans = true

    @total_repayments = Txn.where(txn_type: 'c2b').sum(:value)
    @total_borrowers = Loan.distinct.count('farmer_id')
    @total_loan_amount = Loan.sum :value

    @borrower_gender = {
      'Male' => Farmer.where(received_loans: true).where(gender: 'male').count,
      'Female' => Farmer.where(received_loans: true).where(gender: 'female').count
    }
    @borrower_age_range = {
      'Youth' => Farmer.where(received_loans: true).where('year_of_birth >= ?', Time.now.year - 35).count,
      'Adult' => Farmer.where(received_loans: true).where('year_of_birth < ?', Time.now.year - 35).count
    }

    @loan_amount_gender = {
      'Male' => Farmer.joins(:loans).where("farmers.gender = ?", 'male').sum(:value),
      'Female' => Farmer.joins(:loans).where("farmers.gender = ?", 'female').sum(:value)
    }
    @loan_amount_age_range = {
      'Youth' => Farmer.joins(:loans).where('farmers.year_of_birth >= ?', Time.now.year - 35).sum(:value),
      'Adult' => Farmer.joins(:loans).where('farmers.year_of_birth < ?', Time.now.year - 35).sum(:value)
    }

    @country = params[:country]
    @loan_type = params[:loan_type]
    @date_gt = params[:date_greater_than]
    @date_lt = params[:date_less_than]

    if (@country.present?) && (@country != '-') && (@loan_type.present?) && (@loan_type != '-')
      @show_tables = true
      if @country == 'kenya'
        currency = 'KES'
      elsif @country = 'uganda'
        currency = 'UGX'
      else
        currency = ''
      end
      base_loans = Loan.where(currency: currency).where(time_period: @loan_type)
      defaulted_loans = base_loans.where("disbursed_date < ?", Date.today - 6.months)
      uniq_default_farmer_ids = defaulted_loans.pluck(:farmer_id).uniq
      @num_defaulters = uniq_default_farmer_ids.count
      @total_default_amount = defaulted_loans.sum(:value)
      @defaulter_gender = {
        'Male' => Farmer.where(id: uniq_default_farmer_ids).where(gender: 'male').count,
        'Female' => Farmer.where(id: uniq_default_farmer_ids).where(gender: 'female').count
      }
      @defaulter_age_range = {
        'Youth' => Farmer.where(id: uniq_default_farmer_ids).where('year_of_birth >= ?', Time.now.year - 35).count,
        'Adult' => Farmer.where(id: uniq_default_farmer_ids).where('year_of_birth < ?', Time.now.year - 35).count,
      }

      input_loans = base_loans.where(commodity: 'inputs')
      @input1 = 0
      @input2 = 0
      @input3 = 0
      @input4 = 0
      @input5 = 0
      @input6 = 0
      input_loans.each do |l|
        if l.amount_remaining > 0
          if l.loan_maturity_date.present?
            days_due = (Date.today - l.loan_maturity_date.to_date).to_i
            if (days_due >= 0) && (days_due < 31)
              @input1 += l.amount_remaining
            elsif (days_due >= 31) && (days_due < 61)
              @input2 += l.amount_remaining
            elsif (days_due >= 61) && (days_due < 91)
              @input3 += l.amount_remaining
            elsif (days_due >= 91) && (days_due < 121)
              @input4 += l.amount_remaining
            elsif (days_due >= 121) && (days_due < 181)
              @input5 += l.amount_remaining
            elsif (days_due >= 181)
              @input6 += l.amount_remaining
            end
          end
        end
      end

      cash_loans = base_loans.where(commodity: 'cash')
      @cash1 = 0
      @cash2 = 0
      @cash3 = 0
      @cash4 = 0
      @cash5 = 0
      @cash6 = 0
      cash_loans.each do |l|
        if l.amount_remaining > 0
          days_due = (Date.today - l.loan_maturity_date.to_date).to_i
          if (days_due >= 0) && (days_due < 31)
            @cash1 += l.amount_remaining
          elsif (days_due >= 31) && (days_due < 61)
            @cash2 += l.amount_remaining
          elsif (days_due >= 61) && (days_due < 91)
            @cash3 += l.amount_remaining
          elsif (days_due >= 91) && (days_due < 121)
            @cash4 += l.amount_remaining
          elsif (days_due >= 121) && (days_due < 181)
            @cash5 += l.amount_remaining
          elsif (days_due >= 181)
            @cash6 += l.amount_remaining
          end
        end
      end

      @total_repayments = Txn.where(txn_type: 'c2b').sum(:value)
      @total_borrowers = base_loans.distinct.count('farmer_id')
      @total_loan_amount = base_loans.sum :value
      repayments = base_loans.map { |loan| loan.amount_paid / loan.amount_due }
      @avg_loan_repayment_rate = ((repayments.sum / repayments.count) * 100).round(2)
      uniq_borrower_farmer_ids = base_loans.pluck(:farmer_id).uniq
      @borrower_gender = {
        'Male' => Farmer.where(id: uniq_borrower_farmer_ids).where(gender: 'male').count,
        'Female' => Farmer.where(id: uniq_borrower_farmer_ids).where(gender: 'female').count
      }
      @borrower_age_range = {
        'Youth' => Farmer.where(id: uniq_borrower_farmer_ids).where('year_of_birth >= ?', Time.now.year - 35).count,
        'Adult' => Farmer.where(id: uniq_borrower_farmer_ids).where('year_of_birth < ?', Time.now.year - 35).count,
      }

    end


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
