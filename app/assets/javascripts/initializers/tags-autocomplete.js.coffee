$ ->
  $("input.with_autocomplete").each ->
    $input = $(@)
    $input.autocomplete
      source: (request, response) =>
        $.getJSON $input.data('url'),
                  term: request.term.split( /,\s*/ ).pop()
        , response
      minLength: 2
      focus: ->
        false
      select: (event, ui) ->
        $input.siblings("input[type='hidden']").val ui.item.id
        terms = @value.split( /,\s*/ )
        terms.pop()
        terms.push ui.item.value
        terms.push ""
        @value = terms.join(", ")
        false
