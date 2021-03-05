# encoding : utf-8
class DictionaryConstraint
  def matches? request
    site, subdomain = SiteFinder.find_site request
    site.dictionaries.where(:link => request.params[:link]).exists?
  end
end