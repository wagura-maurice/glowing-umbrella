class Loan < ActiveRecord::Base
  belongs_to :farmer
  has_and_belongs_to_many :txns

  before_create :set_defaults

  include Exportable

  def self.search_fields
    return {"created_at" => {type: :time, key: "Registration Date"},
            "commodity" => {type: :string, key: "Commodity"},
            "value" => {type: :number, key: "Principal"},
            "interest_rate" => {type: :number, key: "Interest Rate"},
            "interest_period" => {type: :string, key: "Interest Period"},
            "structure" => {type: :string, key: "Loan Structure"},
            "status" => {type: :string, key: "Loan Status"},
            "disbursed_date" => {type: :time, key: "Disbursed Date"},
            "repaid_date" => {type: :time, key: "Repaid Date"},
            "disbursal_method" => {type: :string, key: "Disbursal Method"},
            "farmer_id" => {type: :string, key: "Farmer ID"},
            }
  end

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

  def set_service_charge
    pct = (self.service_charge_percentage || 0.0) / 100.0
    value = self.value || 0.0
    self.service_charge = value * pct
    self.save
  end

  def amount_due
    total_interest = self.duration * self.interest_rate
    return self.value * (1 + (total_interest/100)) + self.service_charge
  end

  def amount_remaining
    return self.amount_due - self.amount_paid
  end

  def effective_loan_interest_rate
    return self.interest_rate
  end


  def loan_maturity_date
    str = self.duration.to_s
    if ['year', 'month', 'day'].include? self.duration_unit
      str += ".#{self.duration_unit}"
    else
      return nil
    end
    puts "IN LOAN loan_maturity_date"
    puts "SELF DISBUSRED DATE #{self.disbursed_date}"
    puts "SELF DURATION UNIT #{self.duration_unit}"
    return self.disbursed_date + eval(str)
  end

  def next_payment_date
    if ['year', 'month', 'day'].include? self.duration_unit
      str = "1.#{self.duration_unit}"
    else
      return nil
    end
    return self.disbursed_date + eval(str)
  end

  def monthly_payment
    return (self.amount_due / self.duration).round(2)
  end

  # TO DO
  def credit_life_fee
    return 1000
  end


  def formatted_disbursal_date
    return formatted_date(self.disbursed_date)
  end


  def formatted_repaid_date
    return formatted_date(self.repaid_date)
  end


  def formatted_date(str)
    return nil if str.nil?
    return str.strftime("%d-%m-%Y")
  end


  def formatted_created_at
    return formatted_date(self.created_at)
  end

  def formatted_maturity_date
    return formatted_date(self.loan_maturity_date)
  end

  def formatted_payment_date
    return formatted_date(self.next_payment_date)
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
