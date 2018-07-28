ready = ->
  $('#farmers-table').dataTable
    processing: true
    serverSide: true
    ajax: $('#farmers-table').data('source')
    pagingType: 'full_numbers'
    stateSave: true
    columns: [
      {data: 'name'}
      {data: 'phone_number'}
      {data: 'status'}
      {data: 'nearest_town'}
      {data: 'county'}
      {data: 'national_id_number'}
      {data: 'association_name'}
      {data: 'year_of_birth'}
      {data: 'gender'}
      {data: 'farm_size'}
      {data: 'registration_time'}
    ]

$(document).ready(ready)
$(document).on('turbolinks:load', ready)