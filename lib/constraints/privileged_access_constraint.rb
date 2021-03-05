class PrivilegedAccessConstraint
  def self.matches?(request)
    current_user = request.env['warden'].user
    return false if current_user.blank?
    current_user.is_admin? || current_user.site_admins.where(:role => ['admin', 'editor', 'moderator']).any?
  end
end