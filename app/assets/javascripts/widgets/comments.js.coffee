class App.Widgets.Comments extends Ultimate.Plugin

  el: '.js-comments'

  cachedForm: null
  isReply: null
  params: {}

  events:
    'click                      .js-commentReply' : 'showReplyForm'
    'click        .js-commentTurn:not(.disabled)' : 'turn'
    'ajax:success                .js-commentEdit' : 'showEditForm'
    'ajax:error                  .js-commentEdit' : 'showEditFormError'
    'click                 .js-commentCancelEdit' : 'cancelEdit'
    'click                   .js-commentSendEdit' : 'disableEditForm'
    'ajax:success      .js-commentInlineEditForm' : 'editSuccess'
    'ajax:error        .js-commentInlineEditForm' : 'editError'
    'ajax:success                .js-commentForm' : 'addComment'
    'ajax:error                  .js-commentForm' : 'addCommentError'
    'ajax:success        .js-rate:not(.disabled)' : 'rate'
    'click                       .js-commentsNew' : 'showNew'
    'click                     .js-commentsRated' : 'showRated'
    'click                   .js-commentsRegular' : 'showRegular'
    'click                    .js-commentsAction' : 'commentsAction'
    'click                  .js-commentsCollapse' : 'toggleCommentsCollapse'

  initialize: ->
    @cachedForm = @$('.js-commentForm').clone()
    @params =
      doc_class: @$el.data('class')
      doc_id: @$el.data('id')
    @loadComments()

    $(document).on 'ajax:success', '.js-commentForm form', (data, status, xhr) =>
        console.log($($.parseHTML(status.comment)).find('.js-comment').attr('id'))
        @loadComments()
        setTimeout =>
          @addComment(data, status)
        , 200

  loadComments: (replace) ->
    $.ajax
      url: '/comments'
      dataType: 'json'
      data: @params
      success: (results) =>
        if replace
          $('.js-comments').first().html(results.comments)
        else
          @$el.empty().prepend(results.comments)

  showReplyForm: (event) ->
    jTrigger = $ event.currentTarget
    jComment = jTrigger.closest('.js-comment')
    unless jComment.hasClass('js-replied')
      jComment.addClass('js-replied')
      jTrigger.addClass('disabled').text 'Отменить'
      level = jTrigger.parents('.js-comment').length
      jReplyContainer = @cachedForm
      jReplyForm = jReplyContainer.find('form')
      jReplyForm.find('#comment_parent_id')?.remove()
      jReplyForm.find('#comment_level')?.remove()
      jReplyForm.append "<input type='hidden' name='comment[parent_id]' id='comment_parent_id' value=#{jComment.attr('id')}>"
      jReplyForm.append "<input type='hidden' id='comment_level' value='#{level + 1}'>"
      @isReply = jComment.attr('id')
      jComment.append(jReplyContainer)
      if jComment.children('.js-commentsList').length
        jReplyContainer.insertBefore jComment.children('.js-commentsList')
      else
        jComment.append(jReplyContainer)
    else
      jComment.removeClass('js-replied')
      jTrigger.addClass('disabled').text 'Ответить'
      jComment.children('.js-commentForm').remove()
    jTrigger.removeClass 'disabled'

  turn: (event) ->
    jTrigger = $ event.currentTarget
    jTrigger.addClass('disabled')
    list = jTrigger.closest('.js-comment').children('.js-commentsList')
    unless list.hasClass('js-turned')
      list.addClass 'js-turned'
      jTrigger.text 'Ответов: ' + list.children('.g-comment').length
      list.slideUp 300, -> jTrigger.removeClass 'disabled'
    else
      list.removeClass('js-turned')
      jTrigger.text 'Свернуть'
      list.slideDown 300, -> jTrigger.removeClass 'disabled'

  showEditForm: (event, data, status, xhr) ->
    jTrigger = $ event.currentTarget
    jTrigger.addClass('disabled')
    jComment = jTrigger.closest('.js-comment')
    text = jComment.children('.js-commentText')
    text.hide()
    text.after data.comment

  showEditFormError: (event, data, status, xhr) ->
#    cout 'form obtain error', event, '//', data, '//', status, '//', xhr

  cancelEdit: (event) ->
    jTrigger = $ event.currentTarget
    jComment = jTrigger.closest('.js-comment')
    jComment.children('.js-commentText').show()
    jComment.children('.js-commentInlineEdit').remove()
    jComment.find('.js-commentEdit.disabled').removeClass('disabled')

  disableEditForm: (event) ->
    $(event.currentTarget).addClass('disabled')

  editSuccess: (event, data, status, xhr) ->
    jTrigger = $ event.currentTarget
    jComment = jTrigger.closest('.js-comment')
    jComment.children('.js-commentText').text(data.comment).show()
    jComment.find('.js-commentEdit.disabled').removeClass('disabled')
    jTrigger.parent().remove()

  editError: (event, data, status, xhr) ->
    $(event.currentTarget).find('.js-commentEditText').attr('disabled', false)
#    cout 'edit error:', event, '//', data, '//', status, '//', xhr

  addComment: (event, data) ->
    if @isReply
      jParent = @$("##{@isReply}")
      if jParent.children('.js-commentsList').length
        jParent.children('.js-commentsList').append data.comment
      else jParent.append("<div class='g-comments__list js-commentsList'>#{data.comment}</div>")
      $(event.currentTarget).remove()
      jParent.removeClass('js-replied').find('.js-commentReply').text 'Ответить'
      @isReply = null
    else
      @$('.js-commentsList').first().append data.comment
      $(event.currentTarget).find('.js-commentEditText').val('')
    @cachedForm.find('.js-commentEditText').val('')
    #jComment = $("##{$(data.comment).attr('id')}")
    #if jComment.offset().top > $(window).scrollTop() + $(window).height()
    #  a = jComment.offset().top + jComment.outerHeight() - $(window).height()
    #  $('body').animate({scrollTop:a}, '500', 'swing')
    #  jComment.addClass('attention')
    @refreshCounter()

  addCommentError: (event, data, status, xhr) ->
#    cout 'add comment error', event, '//', data, '//', status, '//', xhr

  refreshCounter: ->
    @$('.js-commentsCount').text @$('.js-comment').length

  rate: (event, data) ->
    jTarget = $(event.currentTarget)
    jTarget.siblings('.js-rate').addBack().addClass('disabled')
    jTarget.parent().replaceWith(data.rate)

  commentsAction: (event) ->
    $(event.currentTarget).addClass('processing')

  showNew: (event, data) ->
    @params['order'] = 'new'
    @loadComments(true)

  showRated: (event, data) ->
    @params['order'] = 'rating'
    @loadComments(true)

  showRegular: (event, data) ->
    @params['order'] = 'regular'
    @loadComments(true)

  toggleCommentsCollapse: (event) ->
    $(".g-comments, .g-comment-form-wrapper").toggleClass("collapsed")
    $(".js-commentsCollapse").toggleClass("active")
    if $(".collapse-message").text().trim() == "Показать"
      $(".collapse-message").text("Скрыть")
    else
      $(".collapse-message").text("Показать")