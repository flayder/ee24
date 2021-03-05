#encoding: utf-8
require 'with_site'

module TagExtend
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      include WithSite
      attr_accessible :name, :link, :tagging_ids, as: :admin
      validates :name, uniqueness: { scope: :site_id, case_sensitive: false }, format: { with: /\A[a-zA-Z\dа-яА-ЯёЁ\-\s]+\z/ }
      validates :link, uniqueness: { scope: :site_id, case_sensitive: false }, format: { with: /\A[a-zA-Z\-\d\s]+\z/ }, presence: true

      before_validation :generate_link, on: :create
      after_update :update_seo

      #кол-во тегов без статей, событий и пр
      def self.without(taggable_type, site)
        tag_ids = ActsAsTaggableOn::Tag.select('tags.*').site(site).joins(:taggings).group('taggings.tag_id').where(taggings: {taggable_type: taggable_type}).map(&:id)
        conditions = tag_ids.present? ? ['id not in (?)', tag_ids] : true
        ActsAsTaggableOn::Tag.site(site).where(conditions)
      end
    end
  end

  module InstanceMethods
    def has_description?
      #true
      self.seo.present?
    end

    def seo
      self.site.seos.where(path: URI::encode(self.url)).where('text is not null and text != ""').first
    end

    def validates_name_uniqueness?
      false
    end

    def to_param
      "#{link}"
    end

    def url
      "/tags/#{link}"
    end

    def generate_link
      unless self.link?
        self.link = Russian::transliterate(self.name)
      end
    end

    def update_seo
      if self.link_changed?
        seo = self.site.seos.where(path: URI::encode("/tags/#{self.link_was}")).where('text is not null and text != ""').first
        if seo.present?
          seo.path = URI::encode(self.url)
          seo.save!
        end
      end
    end
  end
end

unless ActsAsTaggableOn::Tag.included_modules.include?(TagExtend)
  ActsAsTaggableOn::Tag.send(:include, TagExtend)
end

module TaggingExtend
  def self.included(base)
    base.send(:include, InstanceMethods)

    base.class_eval do
      validates :tag_id, uniqueness: { scope: [:taggable_id, :taggable_type] }
    end
  end
  module InstanceMethods

  end
end

unless ActsAsTaggableOn::Tagging.included_modules.include?(TaggingExtend)
  ActsAsTaggableOn::Tagging.send(:include, TaggingExtend)
end
