module StylesheetFilter
  include ActionView::Helpers::TagHelper
  def stylesheet_template name
    content_tag(:link, nil, href: "/design/stylesheets/#{name}.css", media: "screen", rel: "stylesheet", type: "text/css")
  end
end
