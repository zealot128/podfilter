
$(document).on 'page:load page:change ready', ->
  console.log 'triggerd'
  $('.js-upload').fileupload
    dataType: 'json'
    add:  (e,data)->
      $('.js-upload-target').html('uploading...')
      data.submit()
    done: (e,data)->
      html = """
      <pre>
      Finished!<br/>
      #{data.result.log.join('<br/>')}
      <p><a href='#{data.result.url}' class='btn btn-primary'>Hier gehts weiter</a></p>
      </pre>
      """
      $('.js-upload-target').html(html)
  .prop('disabled', !$.support.fileInput)
  .parent().addClass($.support.fileInput ? undefined : 'disabled');
