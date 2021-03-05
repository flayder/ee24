class CatalogDescription < ActiveRecord::Base
  COMMON_FIELDS = [:language, :title, :annotation, :text, :approved]
  ADMIN_FIELDS = COMMON_FIELDS | [ { :as => :admin }]
  attr_accessible *COMMON_FIELDS
  attr_accessible *ADMIN_FIELDS

  belongs_to :catalog, touch: true

  after_save :update_rubrics_counter

  def self.by_language(language = I18n.locale.to_s)
    where("language = ?", language)
  end

  private

  def update_rubrics_counter
    if self.title_changed?
      catalog.catalog_join_rubrics.each { |element| element.touch }
    end
  end
end
