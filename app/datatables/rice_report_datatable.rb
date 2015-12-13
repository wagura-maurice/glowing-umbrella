class RiceReportDatatable < AjaxDatatablesRails::Base

  def_delegator :@view, :link_to
  def_delegator :@view, :edit_rice_report_path

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['Farmer.name', 'RiceReport.created_at', 'RiceReport.kg_of_seed_planted', 'RiceReport.bags_harvested', 'RiceReport.pishori_bags', 'RiceReport.super_bags', 'RiceReport.other_bags']
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
        link_to(record.reporting_time, edit_rice_report_path(record)),
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
    RiceReport.all.includes(:farmer)
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
