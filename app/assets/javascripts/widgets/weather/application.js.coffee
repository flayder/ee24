class App.Widgets.Application extends Ultimate.Plugin

  el: 'body'

  nodes: ->
    jBack:
      selector: ".back"
      jBackCenter:
        selector: "> .back-center"
        jBackImage: "> img.back-image"

  events: ->
    'click     .date-select, .location-select' : '__toggleSelect'
    'click                        .date-range' : '__toggleRange'
    'click                         a.location' : '__toggleLocation'

  initialize: () ->
    $('.l-page').css 'padding-bottom', $('.l-footer').outerHeight()
    $('body').click =>
      @$el.find(".opened").toggleClass 'closed opened'
    if ($('.seo-column').length > 0)
      if $('.seo-column').html().replace(/[\s]*/g, "").length <= 40
        $('article .l-page__center').addClass "one-collumn"
    jDateSelect = @$el.find('select.range')
    jDateSelect.find('option').each ->
      jLink = $("<a href='#' class=\"date-range\" data-range=\"#{$(@).val()}\">#{$(@).text()}</a>")
      $('body').find('.days .container').append jLink
    locationName = @$el.find('.hidden #l option:selected').text()
    @$el.find('.location .text').text(locationName)
    @$el.find('.location').data('days', @$el.find('.hidden #n option:selected').val())
    if $('.location').data('days') == '5dney'
      $('.container .location').addClass('five-days')
    else if $('.location').data('days') == '7dney'
      $('.container .location').addClass('seven-days')
    else if $('.location').data('days') == '10dney'
      $('.container .location').addClass('ten-days')
    else if $('.location').data('days') == '14dney'
      $('.container .location').addClass('fourteen-days')
    daysNumber = @$el.find('.hidden #n option:selected').text()
    @$el.find('.days .text').text daysNumber
    $(window).resize @_resize
    @jBackImage.load @_resize
    @_resize()

  _resize: =>
    imageWidth = @jBackImage.width()
    if imageWidth and @$el.width() > imageWidth
      @jBack.addClass "wide"
    else if @$el.height() > @jBackImage.height()
      @jBack.removeClass "wide"

  __toggleSelect: (event) ->
    jThis = $ event.currentTarget
    jThis.next().toggleClass 'opened closed'
    jThis.toggleClass 'opened closed'
    false

  __toggleRange: (event) ->
    jThis = $ event.currentTarget
    @$el.find('.date-select .text').text jThis.text()
    @$el.find('.date-select, .days .container').toggleClass 'opened closed'

    lastSlashIndex = window.location.href.lastIndexOf("/")
    if lastSlashIndex >  window.location.href.indexOf("/") + 1
      url = window.location.href.substr 0, lastSlashIndex
    else
      url = window.location.href
    window.location = url + '/' + jThis.data('range')
    false

  __toggleLocation: () ->
    @$el.find('.location-select, .location .container').toggleClass 'opened closed'
