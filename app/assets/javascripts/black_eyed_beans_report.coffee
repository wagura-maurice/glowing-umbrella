ready = ->
  $('#black-eyed-beans-reports-table').dataTable
    processing: true
    serverSide: true
    ajax: $('#black-eyed-beans-reports-table').data('source')
    pagingType: 'full_numbers'
    # optional, if you want full pagination controls.
    # Check dataTables documentation to learn more about
    # available options.

$(document).ready(ready)
$(document).on('page:load', ready)