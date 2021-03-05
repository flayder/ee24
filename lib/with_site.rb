module WithSite
  def self.included(base)
    base.class_eval do
      belongs_to :site
      scope :site, lambda { |field| where(site_id: field) }
      scope :evrone_sites, joins(:site).where(sites: { active: true, is_partner: false }).readonly(false)
      validates :site_id, presence: true
    end
  end
end
