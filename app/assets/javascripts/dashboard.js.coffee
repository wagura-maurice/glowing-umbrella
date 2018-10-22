# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

dashReady = ->
  countryForFarmersSelct = $('#country_for_farmers')[0]
  return if (countryForFarmersSelct == undefined)
  farmgerGroupPerCountryTable = $('#farmer_group_per_country_table')[0]
  populateTable = (data) =>
    farmgerGroupPerCountryTable.classList.remove('dontShow')
    tbody = farmgerGroupPerCountryTable.children[1]
    while (tbody.childElementCount > 0)
      tbody.deleteRow(0)
    for key, value of data
      a = document.createElement('td')
      a.innerHTML = key
      b = document.createElement('td')
      b.innerHTML = value.male
      c = document.createElement('td')
      c.innerHTML = value.female
      d = document.createElement('td')
      d.innerHTML = value.male + value.female
      tr = document.createElement('tr')
      tr.appendChild(a)
      tr.appendChild(b)
      tr.appendChild(c)
      tr.appendChild(d)
      tbody.appendChild(tr)

  countryForFarmersSelct.onchange = (event) =>
    val = countryForFarmersSelct.value
    $.getJSON('/farmer_data_by_country', {'country': val}, populateTable)



$(document).ready(dashReady)
$(document).on('turbolinks:load', dashReady)