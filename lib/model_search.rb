module ModelSearch

  def get_queries(query_params, search_fields)
    ret = []
    query_params.each do |k, v|
      if is_query? k, v
        attribute, comparator = get_query_values(k)
        query = {raw: k, attribute: attribute, comparator: comparator, value: v}
        ret << query
      end
    end
    return ret
  end

  def run_queries(model, query_params)
    search_fields = model.search_fields
    queries = get_queries(query_params, search_fields)

    if queries.length == 0
      return base_query
    else
      ret = base_query
      queries.each do |query|
        comp_symbol = get_comp_symbol(query[:comparator], search_fields[query[:attribute]][:type])
        if search_fields[query[:attribute]].has_key? :search_column
          search_attr = search_fields[query[:attribute]][:search_column]
        else
          search_attr = query[:attribute]
        end
        ret = ret.where("#{search_attr} #{comp_symbol} ?", query[:value])
      end
      return ret
    end
  end

  ### Utility functions

  def is_query?(query_key, query_value)
    if query_value == ""
      return false
    end
    return query_key.include? '__'
  end

  def get_query_values(query_key)
    ret = query_key.split('__')
    return ret
  end

  def get_comp_symbol(comparator, type)
    case comparator
    when 'eq'
      if type == :string
        return 'ILIKE'
      else
        return '='
      end
    when 'gt'
      return '>'
    when 'lt'
      return '<'
    end
  end

end
