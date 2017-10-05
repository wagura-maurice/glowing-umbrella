class AgeingReportDatatable < AjaxDatatablesRails::Base

  def_delegator :@view, :link_to
  def_delegator :@view, :edit_farmer_path


  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
      farmer_name:     { source: "Farmer.name",         cond: :like, searchable: true,  orderable: true },
      value:           { source: "Loan.value",          cond: :gteq, searchable: true,  orderable: false },
      remaining_value: { source: "Loan.value",          cond: :gteq, searchable: false,  orderable: false },
      interest_rate:   { source: "Loan.interest_rate",  cond: :gteq, searchable: false, orderable: false },
      loan_maturity:   { source: "Loan.disbursed_date", cond: :date_range, searchable: false, orderable: false },
      next_payment:    { source: "Loan.disbursed_date", cond: :date_range, searchable: false, orderable: false },
      payment_1:       { source: nil,                   cond: :null, searchable: false, orderable: false },
      payment_2:       { source: nil,                   cond: :null, searchable: false, orderable: false },
      payment_3:       { source: nil,                   cond: :null, searchable: false, orderable: false },
      payment_4:       { source: nil,                   cond: :null, searchable: false, orderable: false },
      payment_5:       { source: nil,                   cond: :null, searchable: false, orderable: false },
      payment_6:       { source: nil,                   cond: :null, searchable: false, orderable: false }
    }
  end


  def data
    records.map do |record|
      {
        # example:
        # id: record.id,
        # name: record.name
        farmer_name: link_to(record.farmer.display_name, edit_farmer_path(record.farmer)),
        value: record.value,
        remaining_value: record.value,
        interest_rate: record.interest_rate,
        loan_maturity: record.formatted_maturity_date,
        next_payment: record.formatted_payment_date,
        payment_1: 0,
        payment_2: 0,
        payment_3: 0,
        payment_4: 0,
        payment_5: 0,
        payment_6: 0
      }
    end
  end


  private


  def base_query
    Loan.includes(:farmer).references(:farmer)
  end


  def get_raw_records
    return base_query
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
