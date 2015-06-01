

$(document).on 'page:load page:change ready', ->
  $('.js-datechart').each ->
    element = $(this)

    options = {
      chart:
        zoomTyp: 'x'
      title:
        text: element.attr('title')
      legend:
        enabled: false
      xAxis:
        categories: element.data('labels')
      yAxis:
        title:
          text: '#'
      series: [
        {
          data: element.data('values')
        }
      ]
    }

    element.highcharts(options)
