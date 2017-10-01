class Loan < ActiveRecord::Base
  belongs_to :farmer

  before_create :set_defaults

  def set_defaults
    self.commodity = 'inputs' unless self.commodity.present?
    self.value = 0.0 unless self.value.present?
    self.time_period = 'before planting' unless self.time_period.present?
    self.season = $current_season unless self.season.present?
    self.interest_rate = 3.0 unless self.interest_rate.present?
    self.interest_period = 'month' unless self.interest_period.present?
    self.interest_type = 'simple' unless self.interest_type.present?
    self.duration = 6 unless self.duration.present?
    self.duration_unit = 'month' unless self.duration_unit.present?
    self.currency = 'KES' unless self.currency.present?
    self.service_charge = 0.0 unless self.service_charge.present?
    self.structure = 'installments' unless self.structure.present?
    self.status = 'application started' unless self.status.present?
    self.disbursal_method = 'supplier' unless self.disbursal_method.present?
    self.repayment_method = 'mpesa' unless self.repayment_method.present?
    self.voucher_code = generate_voucher_code(9)
  end


  def effective_loan_interest_rate
    return self.interest_rate
  end


  # TO DO
  def credit_life_fee
    return 1000
  end


  def formatted_disbursal_date
    if self.disbursed_date.present?
      return formatted_time(self.disbursed_date)
    else
      return nil
    end
  end


  def formatted_repaid_date
    if self.disbursed_date.present?
      return formatted_time(self.repaid_date)
    else
      return nil
    end
  end


  def formatted_time(str)
    return str.strftime("%d-%m-%Y")
  end


  def formatted_created_at
    return formatted_time(self.create_at)
  end


  # Generates a random string from a set of easily readable characters
  def generate_voucher_code(size = 9)
    charset = %w{ 2 3 4 6 7 9 A C D E F G H J K M N P Q R T V W X Y Z}
    code = (0...size).map{ charset.to_a[SecureRandom.random_number(charset.size)] }.join
    while Loan.where(voucher_code: code).exists?
      code = (0...size).map{ charset.to_a[SecureRandom.random_number(charset.size)] }.join
    end
    return code
  end


end
