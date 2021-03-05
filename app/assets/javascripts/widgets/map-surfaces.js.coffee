class App.Widgets.MapSurfaces extends Ultimate.Plugin

  el: '.b-large-map-container'

  events:
    'change     select, input[type="checkbox"]' : 'changeFromCheckbox'
    'ajax:success                   .map-popup' : 'showMapPopup'
    'ajax:success .b-large-map-container__form' : 'ajaxSuccess'
    'change                     .js-select' : 'mapRubricsChange'

  changeFromCheckbox: (event) ->
    @$('input#from_checkbox').val if $(event.currentTarget).is('select') then '0' else '1'
    @$('.b-large-map-container__form').submit()

  _insertRows: (data) ->
    @$('#pagination').hide()
    @$('table.b-surfaces tbody').empty()
    _.each data, (row, index) =>
      @$('table.b-surfaces tbody').append row

  showMapPopup: (event, data)->
    event.stopPropagation()
    if App.getFirstWidget(App.Widgets.YandexMap)?
      position = $(event.currentTarget).position()
      $('.b-map-container').empty().append(data['template'])
      popupMap = new ymaps.Map('b-yandex-map_popup'
        center: data['coordinates'],
        zoom: 12
      )
      placemark = new ymaps.Placemark(data['coordinates'])
      popupMap.geoObjects.add placemark
      $('.b-map-container').css('top', position.top + 'px').css('left', position.left + 200 + 'px').show()

  ajaxSuccess: (event, data)  ->
    window.mapSurfaces = data
    App.getFirstWidget(App.Widgets.YandexMap)?._yaMapsInit()

  mapRubricsChange: (event) ->
    jThis = $ event.currentTarget
    level = parseInt(jThis.attr("id").replace("rubric_select_", ""))
    rubric_id = jThis.val()
    rubric_id = $("select#rubric_select_" + (level - 1)).val()  if rubric_id is "" and level > 0
    $.ajax
      url: "/map/load_marks",
      data:
        rubric_id: rubric_id
      success: (data) =>
        @ajaxSuccess(null, data)
    if level < 2
      $("select#rubric_select_" + (level + 1)).hide()
      $("select#rubric_select_" + (level + 2)).hide()  if level < 1
      if jThis.val().length > 0
        $.ajax
          url: "/map/get_map_rubrics",
          data:
            rubric_id: jThis.val()
            level: level
          success: (data) ->
            if data.length > 0
              options = "<option value=\"\">Все</option>"
              for i of data
                options += "<option value =\"#{data[i][0]}\">#{data[i][1]}</option>"
              $("select#rubric_select_" + (level + 1)).html(options).show()
