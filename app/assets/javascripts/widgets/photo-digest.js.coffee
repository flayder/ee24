class App.Widgets.PhotoDigest extends Ultimate.Plugin

  el: '.js-photoDigest'

  events:
    'click  .js-prev' : 'prev'
    'click  .js-next' : 'next'

  dx: 0             # ширина ячейки
  const: 2          # по сколько листать
  @list: null

  initialize: ->
    @list = @$('.js-photoList')
    @dx = @$('.js-photoItem:first').outerWidth()
    @clone('prev')
    @list.width @$('.js-photoItem').length * @dx

  prev: ->
    @list.animate({left: "+=#{@dx*@const}"}, 500, 'linear', => @clone('prev'))

  next: ->
    @list.animate({left: "-=#{@dx*@const}"}, 500, 'linear', => @clone('next'))

  clone: (direction) ->
    switch direction
      when 'prev'
        @list.children().slice(-@const).clone().prependTo @list
        @list.css({'left': '-'+@dx*@const+'px'})
        @list.children().slice(-@const).remove()
      when 'next'
        @list.children().slice(0,@const).clone().appendTo @list
        @list.css({'left': '-'+@dx*@const+'px'})
        @list.children().slice(0,@const).remove()
