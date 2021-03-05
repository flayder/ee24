class App.Widgets.SearchForm extends Ultimate.Plugin

  el: '.js-search'

  events:
    'click            .b-search__magnifier-area' : 'submitForm'
    'ajax:success              .b-search__form'  : 'ajaxSuccess'

  submitForm: ->
    @$('.b-search__form').submit()  unless @$('.b-search__input').val() is ''
    false

  ajaxSuccess: (event, data) ->
    event.stopPropagation()
    App.getFirstWidget(App.Widgets.MapSurfaces).ajaxSuccess(null, data)
