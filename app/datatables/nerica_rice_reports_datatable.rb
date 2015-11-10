class NericaRiceReportsDatatable < AjaxDatatablesRails::Base

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['Farmer.name', 'NericaRiceReport.created_at', 'NericaRiceReport.kg_of_seed_planted', 'NericaRiceReport.bags_harvested', 'NericaRiceReport.pishori_bags', 'NericaRiceReport.super_bags', 'NericaRiceReport.other_bags']
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= []
  end

  private

  def data
    records.map do |record|
      [
        # comma separated list of the values for each cell of a table row
        # example: record.attribute,
        record.farmer.name,
        record.reporting_time,
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
    NericaRiceReport.all.includes(:farmer)
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
