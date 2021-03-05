class AuthorizedUsersConstraint
  def self.matches?(request)
    current_user = request.env['warden'].user
    return !current_user.blank?
  end
end
