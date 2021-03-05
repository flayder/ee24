# encoding : utf-8
class RubricConstraint < Struct.new(:controller, :key)
  def matches?(request)
    site, subdomain = SiteFinder.find_site(request)

    link = request.params[key]
    link && site.has_section?(controller) && site.rubrics_for(controller, link).any?
  end
end
