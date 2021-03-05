# encoding:utf-8
require 'progress_bar'
namespace :catalogs do
  # Create SEO data for catalogs objects
  task create_seo: :environment do

    progress_bar = ProgressBar.new(Catalog.count)

    Catalog.find_each do |catalog|
      progress_bar.increment!
      CatalogsParser.create_seo_for_catalog!(catalog)
    end
  end
end
