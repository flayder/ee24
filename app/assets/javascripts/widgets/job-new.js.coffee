class App.Widgets.JobNew extends Ultimate.Plugin

  el: '.js-jobNew'

  events:
    'change select.js-jobIndustrySelect' : 'loadProfessions'
    'change select.js-jobRegionSelect' : 'loadRegions'

  loadProfessions: (event) ->
    jThis = $ event.currentTarget
    industryId = jThis.val()
    jobType = jThis.attr('id').replace('_industry_id', '')
    $.get '/job/professions',
      dataType: 'html'
      industry_id: industryId
      type: jobType
      (data) =>
        @$('#professions').html data

  loadRegions: (event) ->
    jThis = $ event.currentTarget
    regionId = jThis.val()
    regionType = jThis.attr('id').replace('_region_id', '')
    $.get '/job/region_cities',
      dataType: 'json'
      region_id: regionId
      type: regionType
      (data) =>
        @$('.js-jobRegionCities').html data.cities
