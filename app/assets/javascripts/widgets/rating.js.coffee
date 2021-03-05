class App.Widgets.Rating extends Ultimate.Plugin

  el: '#rating_article'

  events:
    'click .rating-action' : 'rateClick'

  nodes:
    jRatingActions:
      selector: '.rating-actions'
      jRateButton: '.rating-action'

  rateClick: (event) ->
    jThis = $ event.currentTarget
    value = if jThis.hasClass 'plus'  then 1 else -1
    unless @jRatingActions.hasClass 'disabled'
      $.post "/doc_ratings/vote",
        dataType: "json"
        value: value
        doc_class: @$el.find("input#doc-class").val()
        doc_id: @$el.find("input#doc-id").val()
        (data) =>
          @jRatingActions.removeClass("active").addClass "disabled"
          @jRateButton.off "click"
          @$el.find("#rating_value_article").html data["rating"]
          @$el.find("v#ratings_cnt").html data["cnt_text"]
    false
