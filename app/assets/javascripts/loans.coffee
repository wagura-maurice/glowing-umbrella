ready = ->
  $('#loans-table').dataTable
    processing: true
    serverSide: true
    ajax: $('#loans-table').data('source')
    pagingType: 'full_numbers'
    stateSave: true
    columns: [
      {data: 'farmer_name'}
      {data: 'commodity'}
      {data: 'value'}
      {data: 'time_period'}
      {data: 'interest_rate'}
      {data: 'interest_period'}
      {data: 'duration'}
      {data: 'duration_unit'}
      {data: 'status'}
      {data: 'disbursed_date'}
      {data: 'disbursal_method'}
      {data: 'created_at'}
    ]

$(document).ready(ready)
$(document).on('turbolinks:load', ready)