class App.Widgets.LoaderByPage extends Ultimate.Plugin

  el: '.js-loaderByPage'

  events:
    'click    .js-loader:not(.disabled)' : 'loadByPage'

  loadByPage: (event) ->
    jTarget = $(event.currentTarget)
    jTarget.addClass('disabled')
    unless jTarget.data('page') is null
      $.ajax
        url: if location.search.length is 0 then location.pathname else location.pathname + location.search
        data: {page: jTarget.data('page')}
        dataType: 'json'
        success: (results) =>
          @$('.col1').append $(results.col1)
          if results.col2 then @$('.col2').append $(results.col2)
          if results.col3 then @$('.col3').append $(results.col3)
          if results.page?
            jTarget.data('page', results.page)
            jTarget.removeClass('disabled')
          else
            jTarget.parent().remove()
        error: ->
          jTarget.removeClass('disabled')
    else
      jTarget.parent().remove()
