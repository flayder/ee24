#encoding: utf-8
module Admin::AdminHelper
  LIST_OF_LANGUAGES = {ru: 'Русский', en: 'English'}

  def link_to_seos rubric
    if rubric.seos.site(@site).any?
      link_to 'SEO тексты', admin_seos_path(:search => { :seo_type_eq => rubric.class.name, :seo_id_eq => rubric.id })
    else
      link_to 'Добавить SEO текст', new_admin_seo_path(:seo => { :seo_type => rubric.class.name, :seo_id => rubric.id })
    end
  end
end
