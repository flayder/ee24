# encoding : utf-8
class VoronezhConstraint
  def matches? request
    site = SiteFinder.find_site request
    site.voronezh?
  end
end
