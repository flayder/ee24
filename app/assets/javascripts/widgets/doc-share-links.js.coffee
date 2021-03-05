class App.Widgets.DocShareLink extends Ultimate.Plugin

  el: '.doc-share-links'

  events:
    'click #addtoblog_link      ': 'showAddToBlock'
    'click #addtoblog_close_link': 'hideAddToBlock'

  showAddToBlock: ->
    @$('#addtoblog').show()
    false

  hideAddToBlock: ->
    @$('#addtoblog').hide()
    false
