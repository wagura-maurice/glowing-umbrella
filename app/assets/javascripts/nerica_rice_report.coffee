ready = ->
  $('#nerica-rice-reports-table').dataTable
    processing: true
    serverSide: true
    ajax: $('#nerica-rice-reports-table').data('source')
    pagingType: 'full_numbers'
    stateSave: true
    columns: [
      {data: 'farmer_name'}
      {data: 'farmer_phone_number'}
      {data: 'farmer_association'}
      {data: 'reporting_time'}
      {data: 'kg_of_seed_planted'}
      {data: 'kg_of_fertilizer'}
      {data: 'bags_harvested'}
      {data: 'pishori_bags'}
      {data: 'super_bags'}
      {data: 'other_bags'}
    ]

$(document).ready(ready)
$(document).on('turbolinks:load', ready)