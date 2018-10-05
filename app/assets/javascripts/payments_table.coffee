ready = ->
  $('#payments-table').dataTable
    processing: true
    serverSide: true
    ajax: $('#payments-table').data('source')
    pagingType: 'full_numbers'
    stateSave: true
    columns: [
      {data: 'farmer_name'}
      {data: 'value'}
      {data: 'account_id'}
      {data: 'completed_at'}
      {data: 'name'}
      {data: 'txn_type'}
      {data: 'phone_number'}
    ]

$(document).ready(ready)
$(document).on('turbolinks:load', ready)