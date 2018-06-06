ready = ->
  $('#users-table').dataTable
    processing: true
    serverSide: true
    ajax: $('#users-table').data('source')
    pagingType: 'full_numbers'
    stateSave: true
    columns: [
      {data: 'email'}
      {data: 'full_name'}
      {data: 'role'}
      {data: 'status'}
    ]

$(document).ready(ready)
$(document).on('turbolinks:load', ready)