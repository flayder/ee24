module SeoValues
  def self.included(base)
    base.class_eval {
      has_many :seos, as: :seo, dependent: :destroy
    }
  end

  def seo(site = nil)
    seos.site(site).by_language.first
  end

  def meta_title(site = nil, add = '')
    seo(site).title + add if seo(site).try(:title)
  end

  def seo_sub_text(site)
    seo(site).try(:sub_text)
  end

  def seo_about(site = nil)
    seo(site).try(:about)
  end

  def seo_text(site = nil)
    seo(site).try(:text)
  end

  def meta_description(site = nil)
    seo(site).try(:description)
  end

  def meta_keywords(site = nil)
    seo(site).try(:keywords)
  end
end
