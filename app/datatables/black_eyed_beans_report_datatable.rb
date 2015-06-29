class BlackEyedBeansReportDatatable < AjaxDatatablesRails::Base

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['Farmer.name', 'BlackEyedBeansReport.created_at', 'BlackEyedBeansReport.kg_of_seed_planted', 'BlackEyedBeansReport.bags_harvested', 'BlackEyedBeansReport.grade_1_bags', 'BlackEyedBeansReport.grade_2_bags', 'BlackEyedBeansReport.ungraded_bags']
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
        record.created_at,
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
    BlackEyedBeansReport.all.includes(:farmer)
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
