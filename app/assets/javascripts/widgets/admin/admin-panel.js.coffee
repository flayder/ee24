class App.Widgets.AdminPanel extends Ultimate.Plugin

  el: 'body'

  events:
    'change                                                                               #site_admin_role' : 'roleChange'
    'change #select_all_topic_ids, #select_all_comment_ids, #select_all_board_ids, #select_all_replies_ids' : 'selectAll'
    'click                                                                                    tr.board_row' : 'boardRowClick'
    'click                                                                                        .handler' : 'sideBar'
    'change                                                                       li.check_box.nested_root' : 'changeNested'
    'click                                                                       #sections_select ul.nav a' : 'sectionSelect'
    'change                                                                                   #topic_id_eq' : 'changeTopicId'


  initialize: ->
    $("#topic_id_eq").autocomplete
      source: '/admin/topics/autocomplete',
      minLength: 3
      select: (event, ui) ->
        $('#search_topic_id_eq').val ui.item.id  if ui.item

    if @$('#site_admin_role').val() == 'editor' or @$('#site_admin_role').val() == 'moderator'
      @$('#sections_select').show()
    @$('#site_admin_role').trigger 'change'
    $.rails.allowAction = (element) ->
      message = element.data('confirm')
      answer = false
      callback = undefined
      confirm_count = element.data('confirm-count')
      return true  unless message
      if $.rails.fire(element, 'confirm')
        answer = $.rails.confirm(message, confirm_count)
        callback = $.rails.fire(element, 'confirm:complete', [answer])
      answer and callback

    $.rails.confirm = (message, count) ->
      count = (if typeof count isnt 'undefined' then count else 0)
      i = 0

      while i < count
        return false  unless confirm('Вы точно хотите удалить это? Осталось ' + (count - i))
        i++
      confirm message

    $('#site_admin_user_email').autocomplete
      source: '/admin/site_admins/users',
      minLength: 3
      select: (event, ui) ->
        $('#site_admin_user_id').val ui.item.id  if ui.item


  changeTopicId: (event) ->
    $("input#search_topic_id_eq").val ""  if $(event.currentTarget).val() is ""

  changeNested: (event) ->
    jThis = $ event.currentTarget
    checkedStatus = jThis.find('input:checkbox').prop('checked')
    jThis.next('ul').find('input:checkbox').prop('checked', checkedStatus)

  sectionSelect: (event) ->
    $('ul.rubric_checkboxes').find('li.active').removeClass('active')
    $('ul.rubric_checkboxes').find('li.' + $(event.currentTarget).data('content')).addClass('active')

  roleChange: (event)->
    if $(event.currentTarget).val() == 'admin' or $(event.currentTarget).val() == 'observer'
      @$('#sections_select').hide()
    else
      @$('#sections_select').show()

  selectAll: ->
    @$('.comment_id_check_box, .board_id_check_box, .topic_id_check_box, .reply_id_check_box').each (index, element) ->
      if $(element).prop('checked')
        $(element).prop 'checked', false
      else
        $(element).prop 'checked', true

  boardRowClick: (event) ->
    board_id = $(event.currentTarget).data('id')
    check_box = $(event.currentTarget).find('input.board_id_check_box')
    if Number(check_box.val()) == board_id
      check_box.prop('checked', !check_box.prop('checked'));

  sideBar: (event)->
    jThis = $ event.currentTarget
    jThis.toggleClass 'opened closed'
    if jThis.hasClass('opened')
      jThis.text('Скрыть меню')
    else
      jThis.text('Показать меню')
    @$('@sidebar').toggleClass 'opened closed'
    @$('@sidebar').animate({
      width: 'toggle'
      }, 100, 'linear')
    @$('@content').toggleClass 'col-lg-9 col-lg-12'
