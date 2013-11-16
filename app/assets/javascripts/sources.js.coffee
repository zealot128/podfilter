
$(document).on 'page:load page:change ready', ->
  console.log 'triggerd'
  $('.js-upload').fileupload
    dataType: 'json'
    add:  (e,data)->
      $('.js-upload-target').html('uploading...')
      data.submit()
    done: (e,data)->
      console.log data
      $('.js-upload-target').html('Finished!')
