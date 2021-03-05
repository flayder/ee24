class App.Widgets.Banks extends Ultimate.Plugin

  el: '#banks_form'

  events:
    'change                        select' : 'selectChange'
    'change        input[type="checkbox"]' : 'checkboxChange'

  selectChange: ->
    @$el.find('input#from_checkbox').val '0'
    @$el.submit()

  checkboxChange: ->
    @$el.find('input#from_checkbox').val '1'
    @$el.submit()
