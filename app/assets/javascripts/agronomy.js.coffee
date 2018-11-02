agReady = ->
  selectForPlantingHarvesting = $('#country_for_planting_harvesting')[0]
  return if (selectForPlantingHarvesting == undefined)
  plantingHarvestingTable = $('#planting_harvesting_per_country_table')[0]

  findGetParameter = (parameterName) ->
    result = null
    tmp = []
    location.search.substr(1).split('&').forEach (item) ->
      tmp = item.split('=')
      if tmp[0] == parameterName
        result = decodeURIComponent(tmp[1])
      return
    result

  populateTable = (data) =>
    plantingHarvestingTable.classList.remove('dontShow')
    tbody = plantingHarvestingTable.children[1]
    while (tbody.childElementCount > 0)
      tbody.deleteRow(0)
    for key, value of data
      a = document.createElement('td')
      a.innerHTML = key
      b = document.createElement('td')
      b.innerHTML = value.kg_seed_planted
      c = document.createElement('td')
      c.innerHTML = value.bags_harvested
      d = document.createElement('td')
      d.innerHTML = value.farmer_count
      tr = document.createElement('tr')
      tr.appendChild(a)
      tr.appendChild(b)
      tr.appendChild(c)
      tr.appendChild(d)
      tbody.appendChild(tr)

  selectedCountry = findGetParameter('country')
  if selectedCountry != null
    selectForPlantingHarvesting.value = selectedCountry
    b = $('#country')[0]
    b.value = selectedCountry
    c2 = $('.c2')[0]
    c2.value = selectedCountry
    $.getJSON('/planting_harvesting_data_by_country', {'country': selectedCountry}, populateTable)

  selectForPlantingHarvesting.onchange = (event) =>
    val = selectForPlantingHarvesting.value
    $.getJSON('/planting_harvesting_data_by_country', {'country': val}, populateTable)

$(document).ready(agReady)
$(document).on('turbolinks:load', agReady)