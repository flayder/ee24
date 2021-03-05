$(document).ready ->
  $('.js-datepicker').datepicker({
    dateFormat: 'yy/mm/dd',
    showOtherMonths: true,
    onSelect: (date) ->
      location.href = "/#{$(this).data('type')}/date/#{date}"
  })
