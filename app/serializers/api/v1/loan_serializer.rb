class Api::V1::LoanSerializer < ActiveModel::Serializer
  attributes :commodity,
    :commodities_lent,
    :value,
    :time_period,
    :year,
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
    :repaid_date,
    :disbursal_method,
    :repayment_method,
    :voucher_code,
    :created_at

  def disbursed_date
    format_date object.disbursed_date
  end

  def repaid_date
    format_date object.repaid_date
  end

  def created_at
    format_time object.created_at
  end


  def format_time(time)
    if time.present?
      return time.strftime("%H:%M %p %d/%m/%y")
    else
      return nil
    end
  end

  def format_date(time)
    if time.present?
      return time.strftime("%d/%m/%y")
    else
      return nil
    end
  end

end
