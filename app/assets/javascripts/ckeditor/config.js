CKEDITOR.editorConfig = function( config )
{
  // Define changes to default configuration here. For example:
  // config.language = 'fr';
  config.uiColor = '#ffffff';

  /* Filebrowser routes */
  // The location of an external file browser, that should be launched when "Browse Server" button is pressed.
  config.filebrowserBrowseUrl = "/ckeditor/attachment_files";

  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Flash dialog.
  config.filebrowserFlashBrowseUrl = "/ckeditor/attachment_files";

  // The location of a script that handles file uploads in the Flash dialog.
  config.filebrowserFlashUploadUrl = "/ckeditor/attachment_files";

  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Link tab of Image dialog.
  config.filebrowserImageBrowseLinkUrl = "/ckeditor/pictures";

  // The location of an external file browser, that should be launched when "Browse Server" button is pressed in the Image dialog.
  config.filebrowserImageBrowseUrl = "/ckeditor/pictures";

  // The location of a script that handles file uploads in the Image dialog.
  config.filebrowserImageUploadUrl = "/ckeditor/pictures";

  // The location of a script that handles file uploads.
  config.filebrowserUploadUrl = "/ckeditor/attachment_files";

  config.allowedContent = true;

  // Rails CSRF token
  config.filebrowserParams = function(){
    var csrf_token, csrf_param, meta,
        metas = document.getElementsByTagName('meta'),
        params = new Object();

    for ( var i = 0 ; i < metas.length ; i++ ){
      meta = metas[i];

      switch(meta.name) {
        case "csrf-token":
          csrf_token = meta.content;
          break;
        case "csrf-param":
          csrf_param = meta.content;
          break;
        default:
          continue;
      }
    }

    if (csrf_param !== undefined && csrf_token !== undefined) {
      params[csrf_param] = csrf_token;
    }

    return params;
  };

  config.addQueryString = function( url, params ){
    var queryString = [];

    if ( !params ) {
      return url;
    } else {
      for ( var i in params )
        queryString.push( i + "=" + encodeURIComponent( params[ i ] ) );
    }

    return url + ( ( url.indexOf( "?" ) != -1 ) ? "&" : "?" ) + queryString.join( "&" );
  };

  // Integrate Rails CSRF token into file upload dialogs (link, image, attachment and flash)
  CKEDITOR.on( 'dialogDefinition', function( ev ){
    // Take the dialog name and its definition from the event data.
    var dialogName = ev.data.name;
    var dialogDefinition = ev.data.definition;
    var content, upload;

    if (CKEDITOR.tools.indexOf(['link', 'image', 'attachment', 'flash'], dialogName) > -1) {
      content = (dialogDefinition.getContents('Upload') || dialogDefinition.getContents('upload'));
      upload = (content == null ? null : content.get('upload'));

      if (upload && upload.filebrowser && upload.filebrowser['params'] === undefined) {
        upload.filebrowser['params'] = config.filebrowserParams();
        upload.action = config.addQueryString(upload.action, upload.filebrowser['params']);
      }
    }
  });

  config.enterMode = CKEDITOR.ENTER_P;
  config.toolbar = 'Easy';

  config.toolbar_Easy =
    [
        ['Source','-','Preview'],
        ['Cut','Copy','Paste','PasteText','PasteFromWord',],
        ['Undo','Redo','-','SelectAll','RemoveFormat'],
        ['Styles','Format', 'Font', 'FontSize'], ['Subscript', 'Superscript', 'TextColor'], ['Maximize','-','About'], '/',
        ['Bold','Italic','Underline','Strike'], ['NumberedList','BulletedList','-','Outdent','Indent','Blockquote'],
        ['JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
        ['Link','Unlink','Anchor'], ['Image', 'Attachment', 'Flash', 'Embed'],
        ['Table','HorizontalRule','Smiley','SpecialChar','PageBreak']
    ];

  config.toolbar_Basic =
  [
    ['Bold', 'Italic'],
    ['Outdent','Indent'],
    ['-', 'NumberedList', 'BulletedList', '-', 'Link', 'Unlink','-', ]
  ];

  config.toolbar_SimpleToQuestions =
    [
        ['Bold', 'Italic'],
        ['NumberedList', 'BulletedList', '-', 'Outdent','Indent'],
        ['Link', 'Unlink'],
        ['Image', 'Readmore', 'RequestForm']
    ];

  config.toolbar_StandartToQuestions =
    [
        ['Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo'],
        ['SpellChecker'],
        ['Link','Unlink','Anchor'],
        ['Image','Table','HorizontalRule','SpecialChar'],
        ['Maximize'],
        ['Source'],
        ['Bold','Italic','Underline','Strike','-','RemoveFormat'],
        ['NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock'],
        ['Styles','Format','Font', 'FontSize'],
        ['TextColor','BGColor'],
        ['Readmore', 'RequestForm']
    ];

  config.extraPlugins = "readmore,request_form";
}

CKEDITOR.on('instanceReady', function(ev) {
  ev.editor.dataProcessor.htmlFilter.addRules({
    elements: {
      $: function(element) {
        // Output dimensions of images as width and height
        if (element.name == 'img') {
          var style = element.attributes.style;
          if (style) {
            // Get the width from the style.
            var match = /(?:^|\s)width\s*:\s*(\d+)px/i.exec(style),
                width = match && match[1];
            // Get the height from the style.
            match = /(?:^|\s)height\s*:\s*(\d+)px/i.exec(style);
            var height = match && match[1];
            if (width && height) {
              element.attributes.style = element.attributes.style.replace(/(?:^|\s)width\s*:/i, 'max-width:');
              element.attributes.style = element.attributes.style.replace(/(?:^|\s)height\s*:/i, 'max-height:');
              element.attributes.style += ' width: 100%;';
            }
          }
        }
        return element;
      }
    }
  });
});
