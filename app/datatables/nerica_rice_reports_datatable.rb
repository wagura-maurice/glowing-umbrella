class NericaRiceReportsDatatable < AjaxDatatablesRails::Base
  include ModelSearch

  def_delegator :@view, :link_to
  def_delegator :@view, :edit_nerica_rice_report_path


  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
      farmer_name:         { source: "Farmer.name",                    cond: :like      , searchable: true,  orderable: true },
      farmer_phone_number: { source: "Farmer.phone_number",            cond: :like      , searchable: true,  orderable: false },
      farmer_association:  { source: "Farmer.association_name",        cond: :like      , searchable: true,  orderable: false },
      reporting_time:      { source: "NericaRiceReport.created_at",          cond: :date_range, searchable: false, orderable: true },
      kg_of_seed_planted:  { source: "NericaRiceReport.kg_of_seed_planted",  cond: :gteq      , searchable: false, orderable: true },
      bags_harvested:      { source: "NericaRiceReport.bags_harvested",      cond: :gteq      , searchable: false, orderable: true },
      pishori_bags:        { source: "NericaRiceReport.pishori_bags",        cond: :gteq      , searchable: false, orderable: true },
      super_bags:          { source: "NericaRiceReport.super_bags",          cond: :gteq      , searchable: false, orderable: true },
      other_bags:          { source: "NericaRiceReport.other_bags",          cond: :gteq      , searchable: false, orderable: true }
    }
  end


  def data
    records.map do |record|
      {
        # example:
        # id: record.id,
        # name: record.name
        farmer_name: link_to(record.farmer.display_name, edit_nerica_rice_report_path(record)),
        farmer_phone_number: record.farmer.phone_number,
        farmer_association: record.farmer.association_name,
        reporting_time: link_to(record.reporting_time, edit_nerica_rice_report_path(record)),
        kg_of_seed_planted: record.kg_of_seed_planted,
        bags_harvested: record.bags_harvested,
        pishori_bags: record.pishori_bags,
        super_bags: record.super_bags,
        other_bags: record.other_bags
      }
    end
  end


  private


  def base_query
    NericaRiceReport.includes(:farmer).references(:farmer)
  end


  def get_raw_records
    records = run_queries(NericaRiceReport, params)
    return records
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
