class App.Widgets.LoaderByDate extends Ultimate.Plugin

  el: '.js-loaderByDate'

  events:
    'click    .js-loader:not(.disabled)' : 'loadByDate'

  loadByDate: (event) ->
    jTarget = $(event.currentTarget)
    jTarget.addClass('disabled')
    $.ajax
      url: jTarget.data('url') + jTarget.data('date')
      dataType: 'json'
      success: (results) =>
        @$('.js-list').append $(results.content)
        jTarget.data('date', results.prev)
        jTarget.removeClass('disabled')
      error: ->
        jTarget.removeClass('disabled')
