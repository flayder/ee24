require 'sitemap_generator'

site = Site.find_by_domain("420on.cz")
news = Doc.news.where(created_at: 2.days.ago..Time.now)

SitemapGenerator::Sitemap.default_host = "https://420on.cz"
SitemapGenerator::Sitemap.namer = SitemapGenerator::SimpleNamer.new(:sitemap, :zero => '_google_news')
SitemapGenerator::Sitemap.create(:include_root => false, :include_index => false) do

  news.each do |item|
    add(item.url, :news => {
        :publication_name => "Информационный портал о жизни в Чехии",
        :publication_language => "ru",
        :title => "#{item.title}",
        :publication_date => "#{item.created_at.strftime("%Y-%m-%d")}",
        :keywords => "#{item.tags.map(&:name).join(', ')}"
    })
  end

end
