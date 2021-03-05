namespace :photos do

  task recreate: :environment do
    Photo.limit(1000).each do |photo|
      begin
        photo.image.recreate_versions!
        p "saved photo #{photo.id} - #{photo.url}"
        p photo.image.url(:medium)
      rescue Exception => e
        p "failed to save - #{photo.id}"
      end
    end
  end

  task update_site_ids: :environment do
    Photo.find_each do |photo|
      begin
        if photo.photo
          photo.update_column :site_id, photo.photo.site_id
        else
          photo.destroy
        end
      rescue NameError => e
        puts e.message
        puts "PHOTO: #{photo.id}"
      rescue Exception => e
        raise e
      end
    end
  end

  task move: :environment do
    #p '/u/apps/onru/shared'
    #dir = Rails.root.join('public', 'system')
    #FileUtils.mkdir_p(dir) unless File.directory?(dir)

    shared = Rails.env == 'production' ? '/u/apps/onru/shared/public' : '/home/light/sites/420on/public'

    site_id = Site.prague.id

    BoardPhoto.site(site_id).each do |photo|
      sync_photos(photo.image, shared)
    end
    Catalog.site(site_id).each do |catalog|
      sync_photos(catalog.logo, shared)
    end
    Photo.site(site_id).each do |photo|
      sync_photos(photo.image, shared)
    end

    site = Site.prague
    sync_photos(site.watermark, shared)
    sync_photos(site.logo, shared)
    sync_photos(site.favicon, shared)
    sync_photos(site.background, shared)
    
    User.all.each do |user|
      sync_photos(user.avatar, shared)
    end
  end

end

def sync_photos(obj, shared)
  if obj.present?
    filename = File.basename(obj.path)
    dir = obj.url.gsub('http://cdn.36on.ru', '').gsub(filename, '')
    FileUtils.mkdir_p("#{shared}#{dir}") unless File.directory?("#{shared}#{dir}")
    system("s3cmd sync s3://new.img.36on.ru#{dir} #{shared}#{dir}")
    puts "moved #{dir}" 
  end
end
