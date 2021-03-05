module WithMultiEditing
  def self.included(base)
    base.class_eval do
      scope :user_sites, lambda { |user, site| user.can_multi_edit? ? evrone_sites : site(site) }
    end
  end
end