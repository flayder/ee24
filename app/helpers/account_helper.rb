module AccountHelper
  def is_my_profile?(user)
    logged_in? && current_user == user
  end

  def user_agreement?
    @site.static_docs.find_by_link('user_agreement').present?
  end

  def social_account_url(options = {})
    uri = URI(options[:host])
    uri.path = "/#{options[:account]}"
    uri.to_s
  rescue URI::InvalidComponentError
    options[:host]
  end
end
