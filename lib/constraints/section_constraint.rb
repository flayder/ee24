class SectionConstraint < Struct.new(:controller)
  def matches?(request)
    site = SiteFinder.find_site(request)
    site.has_section?(controller)
  end
end
