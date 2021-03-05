# encoding : utf-8
module StaticHelper
  def static_doc_menu site
    site.static_docs.main.active.map do |doc|
      link_to doc.title, "#", data: {link: "/#{doc.link}"}, class: 'seo-link'
    end.join(" &nbsp;&nbsp; ").html_safe    
  end
end
