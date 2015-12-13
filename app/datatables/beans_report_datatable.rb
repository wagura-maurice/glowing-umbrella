class BeansReportDatatable < AjaxDatatablesRails::Base

  def_delegator :@view, :link_to
  def_delegator :@view, :edit_beans_report_path

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['Farmer.name', 'BeansReport.reporting_time', 'BeansReport.kg_of_seed_planted', 'BeansReport.bags_harvested', 'BeansReport.grade_1_bags', 'BeansReport.grade_2_bags', 'BeansReport.ungraded_bags']
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
        link_to(record.reporting_time, edit_beans_report_path(record)),
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
    BeansReport.all.includes(:farmer)
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
