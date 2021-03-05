class App.Widgets.RubricSelect extends Ultimate.Plugin

  el: '.b-rubric-container'

  events:
    'change select.rubrics' : 'submitRubricForm'

  submitRubricForm: (event) ->
    jThis = $(event.currentTarget)

    path = jThis.data('path') ? ''
    if _.isEmpty(jThis.data('date'))
      date = ''
    else
      date = "?date=#{jThis.data('date')}"
    if _.isEmpty(jThis.prop('value'))
      #noop
    else
      window.location = window.location.protocol + '//' +  window.location.host + '/' + window.location.pathname.split('/')[1] + '/' + path + jThis.prop('value') + date

