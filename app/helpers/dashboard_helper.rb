module DashboardHelper

  def param_is_query?(query_key, query_value)
    if query_value == "" || query_value.nil?
      return false
    end
    return query_key.to_s.include? '__'
  end

end
