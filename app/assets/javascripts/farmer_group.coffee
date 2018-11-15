ready = ->
  $('#farmer-groups-table').dataTable
    processing: true
    serverSide: true
    ajax: $('#farmer-groups-table').data('source')
    pagingType: 'full_numbers'
    stateSave: true
    columns: [
      {data: 'formal_name'}
      {data: 'short_names'}
      {data: 'county'}
    ]


  $('.directUploadAuditedFinancials').find('input:file').each (i, elem) ->
    idVal = $('.idClass').html();
    fileInput = $(elem)
    form = $(fileInput.parents('form:first'))
    submitButton = form.find('input[type="submit"]')
    progressBar = $('<div class=\'bar\'></div>')
    barContainer = $('<div class=\'progress\'></div>').append(progressBar)
    fileInput.after barContainer
    fileInput.fileupload
      fileInput: fileInput
      url: form.data('url')
      type: 'POST'
      autoUpload: true
      formData: form.data('form-data')
      paramName: 'file'
      dataType: 'XML'
      replaceFileInput: false
      progressall: (e, data) ->
        progress = parseInt(data.loaded / data.total * 100, 10)
        progressBar.css 'width', progress + '%'
        return
      start: (e) ->
        submitButton.prop 'disabled', true
        progressBar.css('background', 'green').css('display', 'block').css('width', '0%').text 'Loading...'
        return
      done: (e, data) ->
        submitButton.prop 'disabled', false
        progressBar.text 'Uploading done'
        # extract key and generate URL from response
        key = $(data.jqXHR.responseXML).find('Key').text()
        url = '//' + form.data('host') + '/' + key
        # create hidden field
        filename = fileInput.attr('name')
        input = $('<input />',
          type: 'hidden'
          name: fileInput.attr('name')
          value: url)
        form.append input
        # get loan app ID
        id = window.location.pathname.split('/')[2]
        # Refresh page
        request = $.ajax(
          url: '/post_upload_audited_financials'
          method: 'POST'
          data: {upload_path: key, id: idVal, filename: filename }
          success: ->
            setTimeout (->
              location.reload()
              return
            ), 12000
            return
        ).fail(->
          alert 'There was an error uploading this file. Please let the IT Team know'
          return
        )
        return
      fail: (e, data) ->
        submitButton.prop 'disabled', false
        progressBar.css('background', 'red').text 'Failed'
        return
    return

  $('.directUploadManagementAccounts').find('input:file').each (i, elem) ->
    idVal = $('.idClass').html();
    fileInput = $(elem)
    form = $(fileInput.parents('form:first'))
    submitButton = form.find('input[type="submit"]')
    progressBar = $('<div class=\'bar\'></div>')
    barContainer = $('<div class=\'progress\'></div>').append(progressBar)
    fileInput.after barContainer
    fileInput.fileupload
      fileInput: fileInput
      url: form.data('url')
      type: 'POST'
      autoUpload: true
      formData: form.data('form-data')
      paramName: 'file'
      dataType: 'XML'
      replaceFileInput: false
      progressall: (e, data) ->
        progress = parseInt(data.loaded / data.total * 100, 10)
        progressBar.css 'width', progress + '%'
        return
      start: (e) ->
        submitButton.prop 'disabled', true
        progressBar.css('background', 'green').css('display', 'block').css('width', '0%').text 'Loading...'
        return
      done: (e, data) ->
        submitButton.prop 'disabled', false
        progressBar.text 'Uploading done'
        # extract key and generate URL from response
        key = $(data.jqXHR.responseXML).find('Key').text()
        url = '//' + form.data('host') + '/' + key
        # create hidden field
        filename = fileInput.attr('name')
        input = $('<input />',
          type: 'hidden'
          name: fileInput.attr('name')
          value: url)
        form.append input
        # get loan app ID
        id = window.location.pathname.split('/')[2]
        # Refresh page
        request = $.ajax(
          url: '/post_upload_management_accounts'
          method: 'POST'
          data: {upload_path: key, id: idVal, filename: filename }
          success: ->
            setTimeout (->
              location.reload()
              return
            ), 12000
            return
        ).fail(->
          alert 'There was an error uploading this file. Please let the IT Team know'
          return
        )
        return
      fail: (e, data) ->
        submitButton.prop 'disabled', false
        progressBar.css('background', 'red').text 'Failed'
        return
    return


  $('.directUploadCertificateOfRegistration').find('input:file').each (i, elem) ->
    idVal = $('.idClass').html();
    fileInput = $(elem)
    form = $(fileInput.parents('form:first'))
    submitButton = form.find('input[type="submit"]')
    progressBar = $('<div class=\'bar\'></div>')
    barContainer = $('<div class=\'progress\'></div>').append(progressBar)
    fileInput.after barContainer
    fileInput.fileupload
      fileInput: fileInput
      url: form.data('url')
      type: 'POST'
      autoUpload: true
      formData: form.data('form-data')
      paramName: 'file'
      dataType: 'XML'
      replaceFileInput: false
      progressall: (e, data) ->
        progress = parseInt(data.loaded / data.total * 100, 10)
        progressBar.css 'width', progress + '%'
        return
      start: (e) ->
        submitButton.prop 'disabled', true
        progressBar.css('background', 'green').css('display', 'block').css('width', '0%').text 'Loading...'
        return
      done: (e, data) ->
        submitButton.prop 'disabled', false
        progressBar.text 'Uploading done'
        # extract key and generate URL from response
        key = $(data.jqXHR.responseXML).find('Key').text()
        url = '//' + form.data('host') + '/' + key
        # create hidden field
        filename = fileInput.attr('name')
        input = $('<input />',
          type: 'hidden'
          name: fileInput.attr('name')
          value: url)
        form.append input
        # get loan app ID
        id = window.location.pathname.split('/')[2]
        # Refresh page
        request = $.ajax(
          url: '/post_upload_certificate_of_registration'
          method: 'POST'
          data: {upload_path: key, id: idVal, filename: filename }
          success: ->
            setTimeout (->
              location.reload()
              return
            ), 12000
            return
        ).fail(->
          alert 'There was an error uploading this file. Please let the IT Team know'
          return
        )
        return
      fail: (e, data) ->
        submitButton.prop 'disabled', false
        progressBar.css('background', 'red').text 'Failed'
        return
    return


$(document).ready(ready)
$(document).on('turbolinks:load', ready)


