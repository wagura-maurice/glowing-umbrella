class FarmerDatatable < AjaxDatatablesRails::Base

  include ModelSearch

  def_delegator :@view, :link_to
  def_delegator :@view, :edit_farmer_path

  def sortable_columns
    # Declare strings in this format: ModelName.column_name
    @sortable_columns ||= ['Farmer.name', 'Farmer.phone_number', 'Farmer.nearest_town', 'Farmer.county', 'Farmer.national_id_number', 'Farmer.association_name', 'Farmer.year_of_birth', 'Farmer.gender']
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
        link_to(record.display_name, edit_farmer_path(record)),
        link_to(record.phone_number, edit_farmer_path(record)),
        record.nearest_town,
        record.county,
        record.national_id_number,
        record.association_name,
        record.year_of_birth,
        record.gender,
        record.registration_time
      ]
    end
  end

  def base_query
    Farmer
  end

  def get_raw_records
    records = run_queries(Farmer, params)
    return records
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
