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
    totalMale = 0
    totalFemale = 0
    totalYouth = 0
    totalAdult = 0
    total = 0
    while (tbody.childElementCount > 0)
      tbody.deleteRow(0)
    for key, value of data
      a = document.createElement('td')
      a.innerHTML = key
      b = document.createElement('td')
      b.innerHTML = value.male
      totalMale += value.male
      c = document.createElement('td')
      c.innerHTML = value.female
      totalFemale += value.female
      e = document.createElement('td')
      e.innerHTML = value.youth
      totalYouth += value.youth
      f = document.createElement('td')
      f.innerHTML = value.adult
      totalAdult += value.adult
      d = document.createElement('td')
      d.innerHTML = value.total
      total += value.total
      tr = document.createElement('tr')
      tr.appendChild(a)
      tr.appendChild(b)
      tr.appendChild(c)
      tr.appendChild(e)
      tr.appendChild(f)
      tr.appendChild(d)
      tbody.appendChild(tr)
    a1 = document.createElement('td')
    a1.innerHTML = 'Total'
    b1 = document.createElement('td')
    b1.innerHTML = totalMale
    c1 = document.createElement('td')
    c1.innerHTML = totalFemale
    d1 = document.createElement('td')
    d1.innerHTML = totalYouth
    e1 = document.createElement('td')
    e1.innerHTML = totalAdult
    f1 = document.createElement('td')
    f1.innerHTML = total
    tr1 = document.createElement('tr')
    tr1.appendChild(a1)
    tr1.appendChild(b1)
    tr1.appendChild(c1)
    tr1.appendChild(d1)
    tr1.appendChild(e1)
    tr1.appendChild(f1)
    tr1.setAttribute("style", "font-weight:800;");
    tbody.appendChild(tr1)


  countryForFarmersSelct.onchange = (event) =>
    val = countryForFarmersSelct.value
    $.getJSON('/farmer_data_by_country', {'country': val}, populateTable)



$(document).ready(dashReady)
$(document).on('turbolinks:load', dashReady)