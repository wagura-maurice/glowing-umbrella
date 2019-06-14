ready = ->
  $('#black-eyed-beans-inputs-table').dataTable
    processing: true
    serverSide: true
    ajax: $('#black-eyed-beans-inputs-table').data('source')
    pagingType: 'full_numbers'
    stateSave: true
    columns: [
      {data: 'farmer_name'}
      {data: 'farmer_phone_number'}
      {data: 'farmer_association'}
      {data: 'reporting_time'}
      {data: 'kg_of_seed'}
      {data: 'bags_of_dap_fertilizer'}
      {data: 'bags_of_npk_fertilizer'}
      {data: 'bags_of_can_fertilizer'}
      {data: 'agro_chem'}
      {data: 'acres_planting'}
      {data: 'season'}
    ]

$(document).ready(ready)
$(document).on('turbolinks:load', ready)