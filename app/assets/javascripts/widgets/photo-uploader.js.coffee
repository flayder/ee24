class App.Widgets.PhotoUploader extends Ultimate.Plugin

  el: '#upload_images'

  events:
    'change  .js-photoInput' : 'assignFile'
    'click       .js-remove' : 'removeFile'
    'click .js-removeAvatar' : 'removeAvatar'

  assignFile: (event) ->
    jTarget = $(event.currentTarget)
    @$('.js-photoTitle').text jTarget.val().replace(/C:\\fakepath\\/i, '')
    @$('.js-photoActions').show()

  removeFile: ->
    @$('.js-photoInput').val()
    @$('.js-photoTitle').html @$('.js-photoTitle').data('default')
    @$('.js-photoActions').hide();

  removeAvatar: ->
    @removeFile();
    @$('.js-avatar').css('opacity', '.3')

