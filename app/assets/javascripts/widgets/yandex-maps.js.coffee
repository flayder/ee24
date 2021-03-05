class App.Widgets.YandexMap extends Ultimate.Plugin

  el: '#b-yandex-map'

  myMap: null
  myCollection: null
  myAtmsCollection: null

  initialize: ->
    ymaps.ready(@_yaMapsInit)

  _yaMapsInit: =>
    if @myMap?
      @myMap.geoObjects.remove @myCollection
      @myMap.geoObjects.remove @myAtmsCollection
    @myMap ||= new ymaps.Map('b-yandex-map'
      center: window.cityCoords,
      zoom: 12
    )
    @myCollection = new ymaps.GeoObjectCollection()
    @myAtmsCollection = new ymaps.GeoObjectCollection()
    if window.mapSurfaces?
      if @$el.hasClass 'large-surface'
        @myMap.controls.add('typeSelector')
        @myMap.controls.add('mapTools')
        @myMap.controls.add('zoomControl')
        if window.location.href.indexOf('traffic') > -1
          @myMap.controls.add('trafficControl')
          @myMap.controls.get('trafficControl').show()
        coords = []
        address = []
        title = []
        bankCoords = []
        bankAddress = []
        bankTitle = []
        if $.isArray(window.nearbyAtms)
          for atm in window.nearbyAtms
            if atm.lat? and atm.lng?
              bankCoords.push [atm.lat, atm.lng]
              bankAddress.push [atm.address]
              bankTitle.push [atm.title]
        if $.isArray(window.mapSurfaces)
          for surface in window.mapSurfaces
            if surface.lat? and surface.lng?
              coords.push [surface.lat, surface.lng]
              address.push [surface.address]
              if surface.link?
                title.push ["<a href='#{surface.link}'>#{surface.title}</a>"]
              else
                title.push [surface.title]
        else
          coords.push [window.mapSurfaces.lat, window.mapSurfaces.lng]
          address.push [window.mapSurfaces.address]
          if window.mapSurfaces.link?
            title.push ["<a href='#{window.mapSurfaces.link}'>#{window.mapSurfaces.title}</a>"]
          else
            title.push [window.mapSurfaces.link]
          if window.mapSurfaces.surface?
            for surface in window.mapSurfaces.surface
              if surface.lat? and surface.lng?
                coords.push [surface.lat, surface.lng]
                address.push [surface.address]
            App.getFirstWidget(App.Widgets.MapSurfaces)._insertRows(window.mapSurfaces.template)
        i = 0
        while i < coords.length
          @myCollection.add new ymaps.Placemark(coords[i],
            balloonContentHeader: title[i],
            balloonContent: address[i],
          )
          i++
          @myMap.geoObjects.add @myCollection
        while i < bankCoords.length
          @myAtmsCollection.add new ymaps.Placemark(bankCoords[i],
            balloonContentHeader: bankTitle[i],
            balloonContent: bankAddress[i],
          )
          i++
          @myMap.geoObjects.add @myAtmsCollection
      else
        @myMap.geoObjects.add new ymaps.Placemark([ymaps.geolocation.latitude, ymaps.geolocation.longitude],
          balloonContentHeader: ymaps.geolocation.country
          balloonContent: ymaps.geolocation.city
          balloonContentFooter: ymaps.geolocation.region
        )
      @myMap.setCenter window.cityCoords, 12,
         checkZoomRange: true