class UserDatatable < AjaxDatatablesRails::Base

  include ModelSearch

  def_delegator :@view, :link_to
  def_delegator :@view, :edit_user_path

  def view_columns
    @view_columns ||= {
      email:               { source: "User.email",               cond: :like,       searchable: true,  orderable: true },
      full_name:       { source: "User.full_name",       cond: :like,       searchable: false,  orderable: false },
      role:             { source: "User.role",             cond: :like,       searchable: false, orderable: true },
      status:       { source: "User.activation_state",       cond: :like,       searchable: false, orderable: false }
    }
  end

  def data
    records.map do |record|
      {
        # example:
        # id: record.id,
        # name: record.name
        email: link_to(record.email, edit_user_path(record)),
        full_name: record.full_name,
        role: record.formatted_role,
        status: record.activation_state
      }
    end
  end

  private

  def base_query
    User
  end

  def get_raw_records
    records = run_queries(Farmer, params)
    return records
  end

  # ==== Insert 'presenter'-like methods below if necessary
end
