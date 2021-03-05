class App.Widgets.AdminPanel extends Ultimate.Plugin

  el: '.js-adminPanel'

  events:
    'click  .js-turn' : 'turn'

  turn: ->
    @$el.toggleClass('active')
