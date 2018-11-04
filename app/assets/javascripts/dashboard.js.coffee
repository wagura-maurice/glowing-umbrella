# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

dashReady = ->
  countryForFarmersSelct = $('#country_for_farmers')[0]
  return if (countryForFarmersSelct == undefined)
  farmgerGroupPerCountryTable = $('#farmer_group_per_country_table')[0]


  country_for_farmer_group_select = $('#country_for_farmer_group')[0]
  crop_for_farmer_group_select = $('#crop_for_farmers')[0]

  prePopCropTable = () =>
    val1 = country_for_farmer_group_select.value
    val2 = crop_for_farmer_group_select.value
    return if ((val1 is '-') or (val2 is '-'))

    $.getJSON('/farmer_data_per_crop_by_country', {'country': val1, 'crop': val2}, popCropTable)


  if (country_for_farmer_group_select != undefined)
    country_for_farmer_group_select.onchange = prePopCropTable
    crop_for_farmer_group_select.onchange = prePopCropTable


  popCropTable = (data) =>
    farmer_group_crop_info_per_country_table = $('#farmer_group_crop_info_per_country_table')[0]
    farmer_group_crop_info_per_country_table.classList.remove('dontShow')
    tbody = farmer_group_crop_info_per_country_table.children[1]
    totalKgSeedPlanted = 0
    totalBagsHarvested = 0
    totalAggregatedProduce = 0
    totalProduceCollected = 0
    while (tbody.childElementCount > 0)
      tbody.deleteRow(0)
    for key, value of data
      a = document.createElement('td')
      a.innerHTML = key
      b = document.createElement('td')
      b.innerHTML = value.kg_seed_planted.toFixed(2).toLocaleString('en')
      totalKgSeedPlanted += value.kg_seed_planted
      c = document.createElement('td')
      c.innerHTML = value.total_bags_harvested.toFixed(2).toLocaleString('en')
      totalBagsHarvested += value.total_bags_harvested
      e = document.createElement('td')
      e.innerHTML = value.aggregated_produce.toFixed(2).toLocaleString('en')
      totalAggregatedProduce += value.aggregated_produce
      f = document.createElement('td')
      f.innerHTML = value.produce_collected.toFixed(2).toLocaleString('en')
      totalProduceCollected += value.produce_collected
      tr = document.createElement('tr')
      tr.appendChild(a)
      tr.appendChild(b)
      tr.appendChild(c)
      tr.appendChild(e)
      tr.appendChild(f)
      tbody.appendChild(tr)
    a1 = document.createElement('td')
    a1.innerHTML = 'Total'
    b1 = document.createElement('td')
    b1.innerHTML = totalKgSeedPlanted.toFixed(2).toLocaleString('en')
    c1 = document.createElement('td')
    c1.innerHTML = totalBagsHarvested.toFixed(2).toLocaleString('en')
    d1 = document.createElement('td')
    d1.innerHTML = totalAggregatedProduce.toFixed(2).toLocaleString('en')
    e1 = document.createElement('td')
    e1.innerHTML = totalProduceCollected.toFixed(2).toLocaleString('en')
    tr1 = document.createElement('tr')
    tr1.appendChild(a1)
    tr1.appendChild(b1)
    tr1.appendChild(c1)
    tr1.appendChild(d1)
    tr1.appendChild(e1)
    tr1.setAttribute("style", "font-weight:800;");
    tbody.appendChild(tr1)



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
      b.innerHTML = value.male.toLocaleString('en')
      totalMale += value.male
      c = document.createElement('td')
      c.innerHTML = value.female.toLocaleString('en')
      totalFemale += value.female
      e = document.createElement('td')
      e.innerHTML = value.youth.toLocaleString('en')
      totalYouth += value.youth
      f = document.createElement('td')
      f.innerHTML = value.adult.toLocaleString('en')
      totalAdult += value.adult
      d = document.createElement('td')
      d.innerHTML = value.total.toLocaleString('en')
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
    b1.innerHTML = totalMale.toLocaleString('en')
    c1 = document.createElement('td')
    c1.innerHTML = totalFemale.toLocaleString('en')
    d1 = document.createElement('td')
    d1.innerHTML = totalYouth.toLocaleString('en')
    e1 = document.createElement('td')
    e1.innerHTML = totalAdult.toLocaleString('en')
    f1 = document.createElement('td')
    f1.innerHTML = total.toLocaleString('en')
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