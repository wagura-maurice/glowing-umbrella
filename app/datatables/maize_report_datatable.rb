class MaizeReportDatatable < AjaxDatatablesRails::Base

  def_delegator :@view, :link_to
  def_delegator :@view, :edit_maize_report_path

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['Farmer.name', 'MaizeReport.created_at', 'MaizeReport.kg_of_seed_planted', 'MaizeReport.bags_harvested', 'MaizeReport.grade_1_bags', 'MaizeReport.grade_2_bags', 'MaizeReport.ungraded_bags']
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
        link_to(record.farmer.display_name, edit_maize_report_path(record)),
        record.farmer.phone_number,
        link_to(record.reporting_time, edit_maize_report_path(record)),
        record.kg_of_seed_planted,
        record.bags_harvested,
        record.grade_1_bags,
        record.grade_2_bags,
        record.ungraded_bags
      ]
    end
  end

  def get_raw_records
    # insert query here
    MaizeReport.all.includes(:farmer).references(:farmer)
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
