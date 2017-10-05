ready = ->
  $('#ageing-reports-table').dataTable
    processing: true
    serverSide: true
    ajax: $('#ageing-reports-table').data('source')
    pagingType: 'full_numbers'
    stateSave: true
    columns: [
      {data: 'farmer_name'}
      {data: 'value'}
      {data: 'remaining_value'}
      {data: 'interest_rate'}
      {data: 'loan_maturity'}
      {data: 'next_payment'}
      {data: 'payment_1'}
      {data: 'payment_2'}
      {data: 'payment_3'}
      {data: 'payment_4'}
      {data: 'payment_5'}
      {data: 'payment_6'}
    ]

$(document).ready(ready)
$(document).on('turbolinks:load', ready)