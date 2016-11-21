class SoyaBeansReportDatatable < AjaxDatatablesRails::Base
  include ModelSearch

  def_delegator :@view, :link_to
  def_delegator :@view, :edit_soya_beans_report_path

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['Farmer.name', 'SoyaBeansReport.created_at', 'SoyaBeansReport.kg_of_seed_planted', 'SoyaBeansReport.bags_harvested', 'SoyaBeansReport.grade_1_bags', 'SoyaBeansReport.grade_2_bags', 'SoyaBeansReport.ungraded_bags']
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
        link_to(record.farmer.display_name, edit_soya_beans_report_path(record)),
        record.farmer.phone_number,
        record.farmer.association_name,
        link_to(record.reporting_time, edit_soya_beans_report_path(record)),
        record.kg_of_seed_planted,
        record.bags_harvested,
        record.grade_1_bags,
        record.grade_2_bags,
        record.ungraded_bags
      ]
    end
  end

  def base_query
    SoyaBeansReport.includes(:farmer).references(:farmer)
  end

  def get_raw_records
    # insert query here
    records = run_queries(SoyaBeansReport, params)
    return records
    SoyaBeansReport.all.includes(:farmer).references(:farmer)
  end

  # ==== Insert 'presenter'-like methods below if necessary
end