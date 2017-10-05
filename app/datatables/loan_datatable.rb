class LoanDatatable < AjaxDatatablesRails::Base

  include ModelSearch

  def_delegator :@view, :link_to
  def_delegator :@view, :edit_farmer_path

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
      farmer_name:      { source: "Farmer.name",           cond: :like      , searchable: true,  orderable: true },
      commodity:        { source: "Loan.commodity",        cond: :like      , searchable: false, orderable: false },
      value:            { source: "Loan.value",            cond: :gteq      , searchable: true,  orderable: true },
      time_period:      { source: "Loan.time_period",      cond: :gteq      , searchable: true,  orderable: true },
      interest_rate:    { source: "Loan.interest_rate",    cond: :gteq      , searchable: false, orderable: true },
      interest_period:  { source: "Loan.interest_period",  cond: :like      , searchable: false, orderable: false },
      duration:         { source: "Loan.duration",         cond: :gteq      , searchable: false, orderable: true },
      duration_unit:    { source: "Loan.duration_unit",    cond: :like      , searchable: false, orderable: false },
      status:           { source: "Loan.status",           cond: :like      , searchable: true,  orderable: true },
      disbursed_date:   { source: "Loan.disbursed_date",   cond: :date_range, searchable: false, orderable: true },
      disbursal_method: { source: "Loan.disbursal_method", cond: :like      , searchable: true,  orderable: false },
      created_at:       { source: "Loan.created_at",       cond: :date_range, searchable: false, orderable: true }
    }
  end

  def data
    records.map do |record|
      {
        # example:
        # id: record.id,
        # name: record.name
        farmer_name: link_to(record.farmer.display_name, edit_farmer_path(record.farmer)),
        commodity: record.commodity,
        value: record.value,
        time_period: record.time_period,
        interest_rate: record.interest_rate,
        interest_period: record.interest_period,
        duration: record.duration,
        duration_unit: record.duration_unit,
        status: record.status,
        disbursed_date: record.formatted_disbursal_date,
        disbursal_method: record.disbursal_method,
        created_at: record.formatted_created_at
      }
    end
  end

  private

  def base_query
    Loan.includes(:farmer).references(:farmer)
  end

  def get_raw_records
    records = run_queries(Loan, params)
    return records
  end

  # ==== These methods represent the basic operations to perform on records
  # and feel free to override them

  # def filter_records(records)
  # end

  # def sort_records(records)
  # end

  # def paginate_records(records)
  # end

  # ==== Insert 'presenter'-like methods below if necessary
end
