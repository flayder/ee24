class App.Widgets.Boards extends Ultimate.Plugin

  el: '.b-board__item '

  events:
    'click .photo-thumb' : 'boardPhotoClick'

  boardPhotoClick: (event) ->
    @$(".big-photo").attr 'src', $(event.currentTarget).attr 'rel'
    false
