# encoding : utf-8
class StaticDocsConstraint
  def matches? request
    site, subdomain = SiteFinder.find_site request
    site && site.static_docs.active.link(request.params[:id]).exists? 
  end
end
