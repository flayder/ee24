#= require bootstrap/tab

jQuery ->
  completer = new GmapsCompleter(
    inputField: '#catalog_street_address'
    errorField: '#gmaps-error'
    debugOn: false)

  completer.autoCompleteInit
    language: 'en'
