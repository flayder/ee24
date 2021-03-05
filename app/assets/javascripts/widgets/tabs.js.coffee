class App.Widgets.Tabs extends Ultimate.Plugin

  el: '.js-tabs'

  events:
    'click  .js-tab' : 'showTab'

  showTab: (event) ->
    jTarget = $(event.currentTarget)
    jContainer = @$(".#{jTarget.data('tab')}")
    unless jTarget.hasClass('active')
      jTarget.addClass('active').siblings().removeClass('active')
      jContainer.addClass('active').siblings().removeClass('active')
