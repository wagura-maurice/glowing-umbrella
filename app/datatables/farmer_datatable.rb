class FarmerDatatable < AjaxDatatablesRails::Base

  def_delegator :@view, :link_to
  def_delegator :@view, :edit_farmer_path

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['Farmer.name', 'Farmer.nearest_town', 'Farmer.county', 'Farmer.national_id_number', 'Farmer.association_name', 'Farmer.year_of_birth', 'Farmer.gender']
  end

  def searchable_columns
    # Declare strings in this format: ModelName.column_name
    @searchable_columns ||= ['Farmer.name', 'Farmer.phone_number', 'Farmer.national_id_number', 'Farmer.association_name']
  end

  private

  def data
    records.map do |record|
      [
        # comma separated list of the values for each cell of a table row
        # example: record.attribute,
        link_to(record.name, edit_farmer_path(record)),
        record.nearest_town,
        record.county,
        record.national_id_number,
        record.association_name,
        record.year_of_birth,
        record.gender
      ]
    end
  end

  def get_raw_records
    # insert query here
    Farmer.all
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
