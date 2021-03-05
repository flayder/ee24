class App.Widgets.BoardNew extends Ultimate.Plugin

  el: '.board_form'

  events:
    'change select#board_board_global_rubric_id'                      : 'loadRubrics'
    'change select#board_board_rubric_id, select#board_board_type_id' : 'extendAdress'

  loadRubrics: (event) ->
    $.get "/board/get_rubrics",
      id: $(event.currentTarget).val()
      (data) =>
        @$('#rubrics_div').html data

  extendAdress: ->
    $.get "/board/get_address",
      board_rubric_id: @$("#board_board_rubric_id").val()
      board_type_id: @$("#board_board_type_id").val()
      (data) =>
        if data
          @$('.extended_address').show()
          @$('.simple_address').hide()
        else
          @$('.extended_address').hide()
          @$('.simple_address').show()
