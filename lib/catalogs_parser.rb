# encoding : utf-8
module CatalogsParser
  module_function

  def create_seo_for_catalog!(catalog)
    site = Site.find_by_domain("420on.cz")

    if site.present?
      path = catalog.url

      seo = Seo.where(site_id: site.id, path: path).first_or_initialize
      seo.title = "#{catalog.title.truncate(200)} | Справочная информация о компании в Чехии"
      seo.description = "Описание услуг в каталоге компаний, контакты и адреса компании, справочная информация о #{catalog.title}, Чехия и Прага"
      seo.save!
    end
  end

end
