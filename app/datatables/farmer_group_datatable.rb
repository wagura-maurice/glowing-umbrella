class FarmerGroupDatatable < AjaxDatatablesRails::Base

  include ModelSearch

  def_delegator :@view, :link_to
  def_delegator :@view, :edit_farmer_group_path

  def view_columns
    @view_columns ||= {
      formal_name:        { source: "FarmerGroup.formal_name",   cond: :like,       searchable: true,  orderable: true },
      short_names:        { source: "FarmerGroup.short_names",   cond: :like,       searchable: true,  orderable: true }    }
  end

  def data
    records.map do |record|
      {
        formal_name: link_to(record.formal_name, edit_farmer_group_path(record)),
        short_names: link_to(record.truncated_short_names, edit_farmer_group_path(record))
      }
    end
  end

  private

  def base_query
    FarmerGroup
  end

  def get_raw_records
    records = run_queries(FarmerGroup, params)
    return records
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
