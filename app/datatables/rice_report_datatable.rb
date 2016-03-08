class RiceReportDatatable < AjaxDatatablesRails::Base
  include ModelSearch

  def_delegator :@view, :link_to
  def_delegator :@view, :edit_rice_report_path

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['Farmer.name', 'RiceReport.created_at', 'RiceReport.kg_of_seed_planted', 'RiceReport.bags_harvested', 'RiceReport.pishori_bags', 'RiceReport.super_bags', 'RiceReport.other_bags']
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= ['Farmer.name', 'Farmer.phone_number', 'Farmer.association_name']
  end

  private

  def data
    records.map do |record|
      [
        # comma separated list of the values for each cell of a table row
        # example: record.attribute,
        link_to(record.farmer.display_name, edit_rice_report_path(record)),
        record.farmer.phone_number,
        record.farmer.association_name,
        link_to(record.reporting_time, edit_rice_report_path(record)),
        record.kg_of_seed_planted,
        record.bags_harvested,
        record.pishori_bags,
        record.super_bags,
        record.other_bags
      ]
    end
  end

  def base_query
    RiceReport.includes(:farmer).references(:farmer)
  end

  def get_raw_records
    # insert query here
    records = run_queries(RiceReport, params)
    return records
    RiceReport.all.includes(:farmer).references(:farmer)
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
