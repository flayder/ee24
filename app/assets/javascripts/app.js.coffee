#= require_self
#= require ultimate/jquery-plugin-class

window.App =
  Widgets: {}
  ProtoWidgets: {}

  widgetsInstances: []

  triggers: {}

  trigger: (event, args...) ->
    for callback in @triggers[event] or []
      callback args...

  bind: (event, callback) ->
    @triggers[event] ||= []
    @triggers[event].push callback

  start: ->
    window.flash = $(".l-page__flashes").ultimateFlash({productionMode: not DEBUG_MODE, detectPlainTextMaxLength: -1, locale: 'ru'}, true)
    @bindWidgets()

  bindWidgets: (jRoot = $('html')) ->
    bindedWidgets = []
    for widgetName, widgetClass of @Widgets when widgetClass::el
      jRoot.find(widgetClass::el).each (index, el) =>
        widget = new widgetClass(el: el)
        cout 'info', "Binded widget #{widgetName}:", widget
        @widgetsInstances.push widget
        bindedWidgets.push widget
    bindedWidgets

  unbindWidgets: (widgets) ->
    widget.undelegateEvents()  for widget in widgets
    @widgetsInstances = _.without(@widgetsInstances, widgets...)

  getFirstWidget: (widgetClass) ->
    for widget in @widgetsInstances
      if widget.constructor is widgetClass
        return widget
    return null

  getAllWidgets: (widgetClass) ->
    _.filter(@widgetsInstances, (widget) -> widget.constructor is widgetClass)
