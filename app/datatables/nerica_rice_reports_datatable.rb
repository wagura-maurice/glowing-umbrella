class NericaRiceReportsDatatable < AjaxDatatablesRails::Base

  def_delegator :@view, :link_to
  def_delegator :@view, :edit_nerica_rice_report_path


  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['Farmer.name', 'NericaRiceReport.created_at', 'NericaRiceReport.kg_of_seed_planted', 'NericaRiceReport.bags_harvested', 'NericaRiceReport.pishori_bags', 'NericaRiceReport.super_bags', 'NericaRiceReport.other_bags']
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= ['Farmer.name', 'Farmer.phone_number']
  end

  private

  def data
    records.map do |record|
      [
        # comma separated list of the values for each cell of a table row
        # example: record.attribute,
        link_to(record.farmer.display_name, edit_nerica_rice_report_path(record)),
        record.farmer.phone_number,
        link_to(record.reporting_time, edit_nerica_rice_report_path(record)),
        record.kg_of_seed_planted,
        record.bags_harvested,
        record.pishori_bags,
        record.super_bags,
        record.other_bags
      ]
    end
  end

  def get_raw_records
    # insert query here
    NericaRiceReport.all.includes(:farmer).references(:farmer)
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
