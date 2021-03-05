# encoding : utf-8
class Site < ActiveRecord::Base
  include WithAd

  belongs_to :city
  has_many :social_widget_codes, :dependent => :destroy
  has_many :web_analytics_blocks, :dependent => :destroy
  has_one :metrika_api_account, :dependent => :destroy

  has_many :static_docs, :dependent => :destroy
  has_many :seos, :dependent => :destroy
  has_many :ad_codes, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :docs, :dependent => :destroy
  has_many :tags, :class_name => :'ActsAsTaggableOn::Tag', :foreign_key => :site_id, :dependent => :destroy
  has_many :users
  has_many :linkers, :dependent => :destroy
  # has_many :sponsor_banners, :dependent => :destroy # This is old code.
  has_many :stat_counters, :dependent => :destroy
  has_many :catalog_rubrics, :dependent => :destroy
  has_many :doc_global_rubrics, :dependent => :destroy
  has_many :dictionaries, :dependent => :destroy
  has_many :dictionary_rubrics, :dependent => :destroy
  has_many :dictionary_objects, :dependent => :destroy
  has_many :catalogs, :dependent => :destroy
  has_many :galleries, :dependent => :destroy
  has_many :site_admins, :dependent => :destroy
  has_many :admins, :through => :site_admins, :class_name => 'User', :source => :user
  has_many :site_sections, :dependent => :destroy
  has_many :sections, :through => :site_sections
  has_many :search_queries, :dependent => :destroy
  has_many :doc_rubrics, :dependent => :destroy
  has_many :external_docs, :dependent => :destroy
  has_many :external_doc_rubrics, :dependent => :destroy
  has_many :photo_rubrics, :dependent => :destroy
  has_many :event_rubrics, dependent: :destroy, order: '(position is null), position'
  has_many :main_blocks, order: '(position is null), position ASC'
  has_many :forecast_districts, class_name: :'Forecast::District'
  has_one  :forecast_settings, class_name: :'Forecast::Settings'
  has_many :forecast_icons, class_name: :'Forecast::Icon'
  has_many :main_menu_links, dependent: :destroy
  has_many :mobile_devices, dependent: :destroy

  has_many :redirects, :dependent => :destroy
  has_many :design_stylesheets, :dependent => :destroy, class_name: :"Design::Stylesheet"
  has_many :design_templates, :dependent => :destroy, class_name: :"Design::Template"
  has_many :versions, :dependent => :destroy

  scope :with_domain, lambda { |domain| where(:domain => domain) }
  scope :not_voronezh, where("domain != '36on.ru'")
  scope :partner, where(:is_partner => true)
  scope :not_partner, where(:is_partner => false)
  scope :active, where(:active => true)
  scope :with_foreca_section, includes(site_sections: :section).where(sections: { controller: 'forecast/locations'})

  # REFACTOR remove portal_title
  validates :short_title, :presence => true
  validates_presence_of :domain, :unless => :subdomain?
  validates_presence_of :subdomain, :unless => :domain?
  validates_uniqueness_of :domain, :if => :domain?
  validates_uniqueness_of :subdomain, :if => :subdomain?
  validates :email, email: true

  mount_uploader :watermark, WatermarkUploader
  mount_uploader :logo, SiteLogoUploader
  mount_uploader :favicon, FaviconUploader
  mount_uploader :background, BackgroundUploader

  COMMON_FIELDS = [:pictureless, :domain, :portal_title, :site_admins_attributes,
                   :short_title, :favicon_cache, :logo_cache, :logo, :section_ids,
                   :is_partner, :city_id, :map_provider, :subdomain, :favicon,
                   :dictionary_types, :omniauth_enabled, :watermark,
                   :watermark_cache, :time_zone, :background, :background_cache,
                   :background_link, :remove_background, :robots,
                   :repeat_background, :email]

  ADMIN_FIELDS = COMMON_FIELDS | [:is_partner, { :as => :admin }]

  attr_accessible *COMMON_FIELDS
  attr_accessible *ADMIN_FIELDS

  after_create :assign_sections_and_rubrics, :create_uploads_folder, :create_metrika_api_account, :create_forecast_settings

  delegate :streets, :to => :city

  alias_attribute :title, :short_title

  class << self
    def all_domains
      pluck(:domain)
    end

    def prague
      Site.find_by_short_title('Прага')
    end

    def voronezh
      Site.find_by_domain('36on.ru')
    end

    def voronezh_id
      1
    end
  end

  def robots
    self[:robots] ||= %(User-Agent: *
Host: #{domain}
Disallow: /*?print=true
Disallow: /*?preview_secret=*
Disallow: /search
Disallow: /account/
Disallow: /auth/
Disallow: /about/
Disallow: /contacts/
Disallow: /pr/
Disallow: /user_agreement/
Disallow: /users/
Sitemap: https://#{domain}/sitemap.xml.gz)
  end

  def available_sections
    Section.order('with_city')
  end

  def images_changed?
    self.favicon_changed? || self.logo_changed?
  end

  def portal_title
    self[:portal_title] || short_title
  end

  def email
    self[:email] ||= 'info@36on.ru'
  end

  def voronezh?
    self.domain == '36on.ru'
  end

  def nefrology?
    self.domain == 'nefrology.ru'
  end

  def spdetki?
    self.domain == 'spdetki.com'
  end

  def tambov?
    domain == '68on.ru'
  end

  def not_partner?
    !is_partner?
  end

  def prague?
    domain == '420on.cz'
  end

  def has_section?(controller)
    self.sections.where(:controller => controller).present?
  end

  def has_services?
    city && has_section?(:map)
  end

  def has_dictionary? link
    link && self.dictionaries.where(:link => link).exists?
  end

  def has_dictionaries?
    dictionaries.any?
  end

  def site_section_for(controller)
    site_sections.joins(:section).where(sections: { controller: controller }).first
  end

  def rubrics_for(controller, link)
    site_section = site_section_for(controller)
    site_section ? site_section.rubrics(link) : []
  end

  def rubrics(class_name)
    class_name.to_s.constantize.site(self)
  end

  def menu_sections
    # FIX create section attribute 'for main menu'
    sections.order('position').where('controller not in ("docs", "map", "weather", "dictionary_objects", "search", "comments")') + self.doc_global_rubrics
  end

  def assign_default_rubrics!
    # TODO
    # create DocGlobalRubric for news
    # create default news rubrics
  end

  def uploads_folder_with_root
    File.join(Rails.root, 'public', self.uploads_folder)
  end

  def uploads_folder
    self.is_partner? ? "/uploads/site_#{self.id}/" : '/uploads'
  end

  def assign_default_rubrics_async
    Resque.enqueue DefaultRubricGeneratorJob, id
  end

  def create_uploads_folder
    if self.is_partner?
      dir = self.uploads_folder_with_root
      Dir.mkdir dir unless File.exists? dir
    end
  end

  #блоки, отображаемые под статьями
  def doc_blocks
    if self.voronezh?
      #hack
      self.main_blocks.where(title: ["Новости", "Интервью", "Авторские колонки", "Авто", "Недвижимость"])
    elsif self.prague?
      self.main_blocks
    else
      []
    end
  end

  def find_main_block(block)
    main_blocks.find(MainBlock::BLOCKS[block])
  end

  private

  def assign_sections_and_rubrics
    if is_partner?
      self.sections << Section.where(
        :controller => ['afisha', 'catalog', 'job']
      )
      assign_default_rubrics_async
    end
  end
end
