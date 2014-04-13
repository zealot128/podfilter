
$(document).on 'page:before-change', ->
  $('body').addClass('app-loading')
.on 'page:load page:change ready', ->
  new FastClick(document.body)
  $('body').removeClass('app-loading')
  $('.js-upload').fileupload
    dataType: 'json'
    fail: (e,data)->
      $('.js-upload-target').html """
      <div class='alert alert-error'>Leider ist beim Upload ein Fehler aufgetraten. Bitte prüfe, dass es sich bei der Datei um eine OPML Datei handelt. Im Zweifelsfall schick mir die Datei an info@stefanwienert.de</div>
      """
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
  .parent().addClass($.support.fileInput ? undefined : 'disabled')
