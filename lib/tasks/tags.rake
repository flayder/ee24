namespace :tags do
  task generate_links: :environment do
    tags = ActsAsTaggableOn::Tag.where('link is null or link != ""')
    tags.each do |tag|
      tag.generate_link
      if tag.save
        p "tag saved #{tag.name} #{tag.link}"
      else
        p "tag not saved - #{tag.name}, #{tag.id}"
      end
    end
  end

  task migrate_seos: :environment do
    tags = ActsAsTaggableOn::Tag.where('link is not null')
    tags.each do |tag|
      seo = tag.site.seos.where(path: URI::encode("/tags/#{tag.name}")).where('text is not null and text != ""').first
      if seo.present?
        seo.path = URI::encode(tag.url)
        seo.save!
        puts "seo saved #{seo.path}"
      end
    end
  end 
end
