class App.Widgets.Dropdown extends Ultimate.Plugin

  el: '.b-filter'

  params: {}

  events:
    'click       .js-control' : 'showDropdown'
    'click           .js-all' : 'checkAll'
    'click      .js-checkbox' : 'uncheckAll'
    'click        .js-search' : 'search'
    'click  .js-selectedItem' : 'removeParam'

  initialize: ->
    @refreshTitle @$('.js-control')

  showDropdown: (event) ->
    jTarget = $(event.currentTarget)
    jContainer = @$(".js-dropdown.#{jTarget.data('target')}")
    if jTarget.hasClass('active')
      jTarget.removeClass('active')
      jContainer.removeClass('active')
      @refreshTitle(jTarget)
    else
      jTarget.siblings().removeClass('active')
      @refreshTitle(jTarget.siblings('.js-control'))
      jTarget.addClass('active')
      jContainer.addClass('active')
    false

  checkAll: (event) ->
    jTarget = $(event.currentTarget)
    if jTarget.is(':checked')
      jTarget.parent().siblings().find('.js-checkbox').prop('checked', false)

  uncheckAll: (event) ->
    jTarget = $(event.currentTarget)
    if jTarget.is(':checked')
      all = jTarget.parent().siblings().find('.js-all')
      if all.is(':checked') then all.prop('checked', false)

  refreshTitle: (controls) ->
    if controls.length is 1
      controls = [controls]
    for control in controls
      target = $(control).data('target')
      jContainer = @$(".js-dropdown.#{target}")
      items = jContainer.find('.js-checkbox:checked')
      count = $(control).find('.js-count')
      title = $(control).find('.js-title')
      if items.length
        unless count.text().length
          title.html $(control).data('activetitle')
        count.html "(выбрано: #{items.length})"
        @params[$(control).data('param')] = []
        for item in items
          @params[$(control).data('param')].push $(item).val()
      else if count.text().length
        @params = {}
        title.html $(control).data('title')
        count.empty()

  search: (event) ->
    jTarget = $(event.currentTarget)
    params = jTarget.siblings('.js-control')
    @refreshTitle(params)
    jTarget.siblings().removeClass('active')
    $.ajax
      url: @$el.data('filter')
      dataType: 'html'
      data: @params
      success: (results) =>
        @$('.js-selected').remove()
        @$el.append $(results)
    $.ajax
      url: @$el.data('results')
      dataType: 'json'
      data: @params
      success: (results) =>
        $('.js-vacanciesList').html results.col1
        jTarget.text jTarget.data('activetitle')

  removeParam: (event) ->
    jTarget = $(event.currentTarget)
    jSection = jTarget.parents('.js-selected').data('section')
    @$("##{jSection}_#{jTarget.data('id')}").prop('checked', false)
    parent = jTarget.parent()
    jTarget.remove()
    if parent.is(':empty') then parent.parent().remove()
    @refreshTitle($(".js-control[data-target='#{jSection}']"))

#  refreshFilter: (results) ->
#    cout 'ajax'
