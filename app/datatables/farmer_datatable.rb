class FarmerDatatable < AjaxDatatablesRails::Base

  include ModelSearch

  def_delegator :@view, :link_to
  def_delegator :@view, :edit_farmer_path

  def view_columns
    @view_columns ||= {
      name:               { source: "Farmer.name",               cond: :like,       searchable: true,  orderable: true },
      phone_number:       { source: "Farmer.phone_number",       cond: :like,       searchable: true,  orderable: true },
      nearest_town:       { source: "Farmer.nearest_town",       cond: :like,       searchable: false, orderable: true },
      county:             { source: "Farmer.county",             cond: :like,       searchable: false, orderable: true },
      national_id_number: { source: "Farmer.national_id_number", cond: :like,       searchable: true,  orderable: true },
      association_name:   { source: "Farmer.association_name",   cond: :like,       searchable: true,  orderable: true },
      year_of_birth:      { source: "Farmer.year_of_birth",      cond: :eq,         searchable: false, orderable: true },
      gender:             { source: "Farmer.gender",             cond: :like,       searchable: false, orderable: true },
      registration_time:  { source: "Farmer.created_at",         cond: :date_range, searchable: false, orderable: true }
    }
  end

  def data
    records.map do |record|
      {
        # example:
        # id: record.id,
        # name: record.name
        name: link_to(record.display_name, edit_farmer_path(record)),
        phone_number: link_to(record.phone_number, edit_farmer_path(record)),
        nearest_town: record.nearest_town,
        county: record.county,
        national_id_number: record.national_id_number,
        association_name: record.association_name,
        year_of_birth: record.year_of_birth,
        gender: record.gender,
        registration_time: record.registration_time
      }
    end
  end

  private

  def base_query
    Farmer
  end

  def get_raw_records
    records = run_queries(Farmer, params)
    return records
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
