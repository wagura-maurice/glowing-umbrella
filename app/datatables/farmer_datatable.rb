class FarmerDatatable < AjaxDatatablesRails::Base

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['Farmer.name', 'Farmer.nearest_town', 'Farmer.county']
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= ['Farmer.name', 'Farmer.phone_number', 'Farmer.national_id_number']
  end

  private

  def data
    records.map do |record|
      [
        # comma separated list of the values for each cell of a table row
        # example: record.attribute,
        record.name,
        record.nearest_town,
        record.county
      ]
    end
  end

  def get_raw_records
    # insert query here
    Farmer.all
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
