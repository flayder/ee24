class App.Widgets.Popup extends Ultimate.Plugin

  el: '.popup-layout'

  events:
    'click                          .popup-close': 'close'
    'ajax:success form[data-remote="true"]': 'ajaxSuccess'

  states:
    CLOSED: 0
    OPENED: 1
    
  options:
    state: 0
    ajaxCache: {}
    jqXHR: null
    jContentSource: null
    jWindow: null
    jTitle: null
    jBody: null

  initialize: ->
    @jWindow = @$('.popup-window')
    @jTitle = @jWindow.find '.title'
    @jBody = @jWindow.find '.body'
    @jLoadingContainer = @jBody
    $(window).on 'scroll resize', @fixPosition

  setTitle: (title) ->
    @jTitle.html title

  setContent: (content) ->
    if @options.jqXHR
      @options.jqXHR.abort()
      @options.jqXHR = null
    @options.jContentSource.append @jBody.children() if @options.jContentSource
    @options.jContentSource = if content instanceof jQuery
      jParent = content.parent()
      if jParent.length then jParent else null
    else
      null
    @jBody.html content
    if content
#      @jWindow.fadeIn 300, =>
#      if @options.state is @states.OPENED
#        @jWindow.attr('href', largePhotoUrl).fadeOut 300
#        false
      @fixPosition()

  show: (title, content) ->
    @close()  if @options.state is @states.OPENED
    @setTitle title
    @setContent content
    @options.state = @states.OPENED
    App.trigger 'popup:show'
    @$el.show()
    @jWindow.data('scrolled', false)
    @$el.prev().show()
    @fixPosition()

  close: =>
    return false  if @options.state is @states.CLOSED
    @options.state = @states.CLOSED
    App.trigger 'popup:close'
    @$el.hide()
    @setContent ''
    @$el.prev().hide()
    false

  setAjaxData: (data) =>
    jData = $ data
    jTitle = jData.find('h1.title, h3.title, h3.title').first()
    if title = jTitle.html()
      @setTitle title
      jTitle.remove()
    @setContent jData

  showAjax: (title, href, cache = false) ->
    @show title, ''
    if cache and @options.ajaxCache[href]
      @setAjaxData @options.ajaxCache[href]
    else
      @options.jqXHR = $.get(
        respondFormat(href, 'json'),
        (data) =>
          @options.jqXHR = null
          @options.ajaxCache[href] = data if cache
          @setAjaxData data.content
        , 'json')

  ajaxSuccess: (event, data, textStatus, jqXHR) =>
    @close()

  fixPosition: (event) =>
    @$el.prev().height 0
    @$el.prev().height $(window).height()
    @$el.height 0
    @$el.height $(window).height()
    @$el.css("position": "fixed")
    @$el.prev().css("position": "fixed")
    jDocWindow = $ window
    scrollTop = 0;
    #jDocWindow.scrollTop()
    windowHeight = jDocWindow.height()
    if @options.state is @states.OPENED
      hBound = 10
      # будем искать новое вертикальное положение попапа
      newTop = false
      popupHeight = @jWindow.outerHeight()
      layoutHeight = @$el.height()
      # свободная вертикаль вокруг попапа
      fSpace = layoutHeight - popupHeight
      # находим вертикальную позицию попапа

      # если для попапа это не первый вызов этого замыкания,
      currentTop = if @jWindow.data('scrolled')
        # то взять его реальную вертикальную позицию,
        parseInt @jWindow.css('top')
      else
        # иначе выставить флаг, означающий первую обработку этим замыканием,
        @jWindow.data('scrolled', true)
        # а за вертикальную позицию взять 10000, гарантирующие появление ввеху видимой области
        10000

      # свободная вертикаль вокруг попапа, относительно window

      hSpace = windowHeight - popupHeight
      # если попап не умещается в окне vk,
      if hSpace < 0
        # innerTop — проекция scrollTop
        innerTop = scrollTop + hBound
        # держим её не менее 10
        innerTop = hBound  if innerTop < hBound
        # если попап ниже верхней границы,
        if currentTop > innerTop
          # прилепим его кверху фрэйма
          newTop = innerTop
        else
          # иначе расчитываем нижнюю видимую границу возможного отображения
          innerBottom = innerTop + windowHeight - hBound * 2
          # и если нижняя граница попапа ушла из кадра вниз,
          if (currentTop + popupHeight) < innerBottom
            # новое вертикальное положение попапа расчитываем от нижней границы видимости
            newTop = innerBottom - popupHeight
      else
        # если всё же умещается в окне
        # находим отступ верхней границы
        # если он не отрицательный и умещается в видимой области,
        if scrollTop >= 0 and (scrollTop + layoutHeight) <= windowHeight
          # центрируем попап
          newTop = fSpace / 2
        else
          # пробуем центрировать
          newTop = scrollTop + hSpace / 2
          # не даём окну всплыть выше верхней границы
          newTop = hBound if newTop < hBound

      # за исключением случаев, когда новую позицию попапа так и не удалось обнаружить
      unless newTop is false
        fSpace -= hBound
        # подним попап, если попап оставит сверху больше возможного вертикального пространства
        newTop = fSpace  if newTop > fSpace
        # выставляем новую позицию попапа
        @jWindow.css 'top', newTop
    # возвращаем новую вертикальную позицию попапа, либо false если вычислить оную не удалось
    true #newTop
