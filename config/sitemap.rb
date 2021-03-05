# encoding : utf-8
require 'sitemap_generator'
SitemapGenerator::Sitemap.default_host = "https://420on.cz"
SitemapGenerator::Sitemap.create do
  #default site
  site = Site.find_by_domain("420on.cz")

  #weather_links
  add weather_path, changefreq: 'daily', priority: 0.8

  #map_links
  add map_index_path, changefreq: 'yearly', priority: 0.8

  #sitemap
  add sitemap_path, changefreq: 'daily', priority: 0.8

  #dictionary_objects_links
  site.dictionaries.find_each do |dict|
    dict.rubrics.find_each do |rubric|
      rubric.dictionary_objects.approved.find_each do |article|
        add article.path, changefreq: 'daily', priority: 0.6, lastmod: article.updated_at
      end
    end
  end

  #photo_links
  add galleries_path, changefreq: 'hourly', priority: 0.8
  add new_gallery_path, changefreq: 'yearly', priority: 0.6

  site.photo_rubrics.find_each do |photo_rubric|
    add photo_rubric.url, changefreq: 'daily', priority: 0.8, lastmod: photo_rubric.updated_at
  end

  site.galleries.approved.find_each do |gallery|
    add gallery.url, changefreq: 'daily', priority: 0.8, lastmod: gallery.updated_at
    gallery.photos.find_each do |photo|
      add photo.url, changefreq: 'daily', priority: 0.6, lastmod: photo.updated_at
    end
  end

  #job_links
  add job_path, changefreq: 'hourly', priority: 0.8
  add vacancies_path, changefreq: 'hourly', priority: 0.6
  add new_vacancy_path, changefreq: 'yearly', priority: 0.6
  #add resumes_path, changefreq: 'hourly', priority: 0.6
  #add new_resume_path, changefreq: 'yearly', priority: 0.6

  Industry.find_each do |industry|
    #add industry.path('resume'), lastmod: industry.updated_at, changefreq: 'daily', priority: 0.6
    add industry.path('vacancy'), lastmod: industry.updated_at, changefreq: 'daily', priority: 0.6
  end

  Profession.find_each do |profession|
    #add profession.path('resume'), lastmod: profession.updated_at, changefreq: 'daily', priority: 0.6
    add profession.path('vacancy'), lastmod: profession.updated_at, changefreq: 'daily', priority: 0.6
  end

  Vacancy.approved.find_each do |vacancy|
    add vacancy.url, changefreq: 'daily', lastmod: vacancy.updated_at, priority: 0.6
  end

  # site.resumes.approved.find_each do |resume|
  #   add resume.url, changefreq: 'daily', lastmod: resume.updated_at, priority: 0.6
  # end

  #catalog_links
  add catalogs_path, changefreq: 'hourly', priority: 0.8

  site.catalog_rubrics.find_each do |rubric|
    add rubric.url
  end

  site.catalogs.approved.find_each do |catalog|
    add catalog.url, lastmod: catalog.updated_at, priority: 0.8
  end

  #afisha_links
  add events_path, changefreq: 'hourly', priority: 0.8

  site.event_rubrics.find_each do |event_rubric|
    add event_rubric.url
  end

  site.events.approved.find_each do |event|
    add event.url, lastmod: event.updated_at, priority: 0.8
  end

  #docs_links
  site.doc_global_rubrics.find_each do |global_rubric|
    add global_rubric.link.prepend('/'), changefreq: 'hourly', priority: 0.8, lastmod: global_rubric.updated_at

    global_rubric.doc_rubrics.find_each do |doc_rubric|
      add doc_rubric.url, changefreq: 'hourly', priority: 0.8, lastmod: doc_rubric.updated_at
    end
  end

  site.docs.approved.find_each do |doc|
    add doc.url, lastmod: doc.updated_at, priority: 0.8
  end
end
