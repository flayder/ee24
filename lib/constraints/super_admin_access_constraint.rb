class SuperAdminAccessConstraint
  def self.matches?(request)
    current_user = request.env['warden'].user
    return false if current_user.blank?
    site, subdomain = SiteFinder.find_site(request)
    Ability.new(current_user, site.id).can?(:manage, Resque)
  end
end