class FarmerDatatable < AjaxDatatablesRails::Base

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['Farmer.name', 'Farmer.country', 'Farmer.county', 'Farmer.crops']
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= ['Farmer.county', 'Farmer.crops']
  end

  private

  def data
    records.map do |record|
      [
        # comma separated list of the values for each cell of a table row
        # example: record.attribute,
        record.name,
        record.county,
        record.country,
        record.crops
      ]
    end
  end

  def get_raw_records
    # insert query here
    Farmer.all
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
