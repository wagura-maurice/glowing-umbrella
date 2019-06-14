class GreenGramsInputDatatable < AjaxDatatablesRails::Base

  include ModelSearch

  def_delegator :@view, :link_to
  def_delegator :@view, :edit_green_grams_input_path


  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      # id: { source: "User.id", cond: :eq },
      # name: { source: "User.name", cond: :like }
      farmer_name:         { source: "Farmer.name",                    cond: :like      , searchable: true,  orderable: true },
      farmer_phone_number: { source: "Farmer.phone_number",            cond: :like      , searchable: true,  orderable: false },
      farmer_association:  { source: "Farmer.association_name",        cond: :like      , searchable: true,  orderable: false },
      reporting_time:      { source: "GreenGramsInput.created_at",         cond: :date_range, searchable: false, orderable: true },
      kg_of_seed:  { source: "GreenGramsInput.kg_of_seed", cond: :gteq      , searchable: false, orderable: true },
      bags_of_dap_fertilizer:  { source: "GreenGramsInput.bags_of_dap_fertilizer", cond: :gteq      , searchable: false, orderable: true },
      bags_of_npk_fertilizer:  { source: "GreenGramsInput.bags_of_npk_fertilizer", cond: :gteq      , searchable: false, orderable: true },
      bags_of_can_fertilizer:  { source: "GreenGramsInput.bags_of_can_fertilizer", cond: :gteq      , searchable: false, orderable: true },
      agro_chem:  { source: "GreenGramsInput.agro_chem", cond: :gteq      , searchable: false, orderable: true },
      acres_planting:  { source: "GreenGramsInput.acres_planting", cond: :gteq      , searchable: false, orderable: true },
      season:  { source: "GreenGramsInput.season", cond: :gteq      , searchable: false, orderable: true }
    }
  end


  def data
    records.map do |record|
      {
        # example:
        # id: record.id,
        # name: record.name
        farmer_name: link_to(record.farmer.display_name, edit_green_grams_input_path(record)),
        farmer_phone_number: record.farmer.phone_number,
        farmer_association: record.farmer.association_name,
        reporting_time: link_to(record.reporting_time, edit_green_grams_input_path(record)),
        kg_of_seed: record.kg_of_seed,
        bags_of_dap_fertilizer: record.bags_of_dap_fertilizer,
        bags_of_npk_fertilizer: record.bags_of_npk_fertilizer,
        bags_of_can_fertilizer: record.bags_of_can_fertilizer,
        agro_chem: record.agro_chem,
        acres_planting: record.acres_planting,
        season: record.season
      }
    end
  end

  private

  def base_query
    GreenGramsInput.includes(:farmer).references(:farmer)
  end


  def get_raw_records
    records = run_queries(GreenGramsInput, params)
    return records
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
