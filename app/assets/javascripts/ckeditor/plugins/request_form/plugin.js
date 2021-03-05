CKEDITOR.plugins.add('request_form', {
    requires: ['fakeobjects'],
    icons: 'requestform',

    getPlaceholderCss : function () {
        return 'img.cke_420_request_form'
            + '{'
            + 'background-image: url(' + CKEDITOR.getUrl(this.path + 'icons/request_form.png') + ');'
            + 'background-position: right center;'
            + 'background-repeat: no-repeat;'
            + 'background-size: contain;'
            + 'clear: both;'
            + 'display: block;'
            + 'float: none;'
            + 'width: 80px;'
            + 'height: 80px;'
            + '}'
    },

    onLoad : function () {
        if (CKEDITOR.addCss) {
            CKEDITOR.addCss(this.getPlaceholderCss());
        }
    },

    init: function (editor) {
        // Register the toolbar buttons.
        editor.ui.addButton('RequestForm', {
            label: 'Добавить форму заявки',
            command: 'insertRequestForm'
        });

        // Register the commands.
        editor.addCommand('insertRequestForm', {
            exec: function () {
                // There should be only one <!--request_form--> tag in document. So, look
                // for an image with class "cke_420_request_form" (the fake element).
                var images = editor.document.getElementsByTag('img');
                for (var i = 0, len = images.count() ; i < len ; i++ ) {
                    var img = images.getItem(i);
                    if (img.hasClass('cke_420_request_form')) {
                        var msg = 'В документе уже есть форма заявки. '
                            + 'Вы хотите удалить ее?'
                        if (confirm(msg)) {
                            img.remove();
                            break;
                        } else {
                            return;
                        }
                    }
                }
                insertComment('request_form');
            }
        });

        // This function effectively inserts the comment into the editor.
        function insertComment(text)
        {
            // Create the fake element that will be inserted into the document.
            // The trick is declaring it as an <hr>, so it will behave like a
            // block element (and in effect it behaves much like an <hr>).
            if (!CKEDITOR.dom.comment.prototype.getAttribute) {
                CKEDITOR.dom.comment.prototype.getAttribute = function () { return ''; };
                CKEDITOR.dom.comment.prototype.attributes = { align: '' };
            }
            var fakeElement = editor.createFakeElement(
                new CKEDITOR.dom.comment(text),
                'cke_420_' + text,
                'hr'
            );

            // This is the trick part. We can't use editor.insertElement()
            // because we need to put the comment directly at <body> level.
            // We need to do range manipulation for that.

            // Get a DOM range from the current selection.
            var range = editor.getSelection().getRanges()[0],
                elementsPath = new CKEDITOR.dom.elementPath(range.getCommonAncestor(true)),
                element = (elementsPath.block && elementsPath.block.getParent()) || elementsPath.blockLimit,
                hasMoved;

            // If we're not in <body> go moving the position to after the
            // elements until reaching it. This may happen when inside tables,
            // lists, blockquotes, etc.
            while (element && element.getName() != 'body') {
                range.moveToPosition(element, CKEDITOR.POSITION_AFTER_END);
                hasMoved = 1;
                element = element.getParent();
            }

            // Insert the fake element into the document.
            range.insertNode(fakeElement);

            // Now, we move the selection to the best possible place following
            // our fake element.
            var next = fakeElement;
            while ((next = next.getNext()) && !range.moveToElementEditStart(next)) {
                // do nothing
            }
            range.select();
        }
    },

    afterInit: function (editor) {
        // Adds the comment processing rules to the data filter, so comments
        // are replaced by fake elements.
        editor.dataProcessor.dataFilter.addRules({
            comment: function (value) {
                if (!CKEDITOR.htmlParser.comment.prototype.getAttribute) {
                    CKEDITOR.htmlParser.comment.prototype.getAttribute = function() { return ''; };
                    CKEDITOR.htmlParser.comment.prototype.attributes = { align: '' };
                }
                if (value == 'request_form') {
                    return editor.createFakeParserElement(
                        new CKEDITOR.htmlParser.comment(value),
                        'cke_420_' + value,
                        'hr'
                    );
                }
                return value;
            }
        });
    }
});
