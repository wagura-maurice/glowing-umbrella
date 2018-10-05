class TxnDatatable < AjaxDatatablesRails::Base

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
      value:        { source: "Txn.value",        cond: :gteq      , searchable: false, orderable: false },
      account_id:            { source: "Txn.account_id",            cond: :like      , searchable: true,  orderable: true },
      completed_at:      { source: "Txn.completed_at",      cond: :like      , searchable: true,  orderable: true },
      name:    { source: "Txn.name",    cond: :like      , searchable: true, orderable: true },
      txn_type:  { source: "Txn.txn_type",  cond: :like      , searchable: true, orderable: true },
      phone_number:         { source: "Txn.phone_number",         cond: :like      , searchable: true, orderable: true }
    }
  end

  def data
    records.map do |record|
      {
        farmer_name: record.farmer.present? ? link_to(record.farmer.display_name, edit_farmer_path(record.farmer)) : 'none',
        value: record.value,
        account_id: record.account_id,
        completed_at: record.completed_at,
        name: record.name,
        txn_type: record.txn_type,
        phone_number: record.phone_number
      }
    end
  end

  private

  def base_query
    Txn.includes(:farmer).references(:farmer)
  end

  def get_raw_records
    records = run_queries(Loan, params)
    return records
  end
end
