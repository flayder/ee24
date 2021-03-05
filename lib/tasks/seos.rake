# encoding:utf-8
namespace :seos do
  #перенос seo тегов в seo страниц
  task :tags_move => :environment do
    seos = Seo.where(seo_type: "ActsAsTaggableOn::Tag").where('about is not null and about != ""')
    seos.each do |seo|
      #нет тега - удаляем
      if seo.seo.nil?
        seo.destroy
        p "destroyed seo ##{seo.id} for non-existant tag ##{seo.seo_id}"
      else
        #перенос
        new_seo = Seo.new
        new_seo.site = seo.site
        new_seo.path = "/tags/#{URI::escape(seo.seo.name)}"
        new_seo.seo_type = ''
        new_seo.text = seo.about
        if new_seo.save
          p "saved seo for tag ##{seo.seo_id} #{seo.seo.name} (site ##{new_seo.site_id})"
          #p new_seo.text
        else
          p "could not save seo for tag ##{seo.seo_id} #{seo.seo.name} (site ##{new_seo.site_id})"
          p new_seo.errors
          #existing_seo = Seo.where(path: new_seo.path, site_id: new_seo.site_id).first
          #p existing_seo.text
          #p 'vs'
          #p new_seo.text
        end
      end
    end
  end

  task :destroy_unused => :environment do
    tagged = Seo.where(seo_type: "ActsAsTaggableOn::Tag")
    #tagged.each(&:destroy)
    puts "tagged - #{tagged.count}"
    tagged.each(&:destroy)
    cgred = Seo.where(seo_type: "CatalogGlobalRubric")
    cgred.each do |c|
      existant_seo = Seo.where(site_id: c.site_id, seo_type: 'CatalogRubric', seo_id: c.seo_id)
      if existant_seo.present?
        puts "seo already exists"
        c.destroy
      else
        c.seo_type = 'CatalogRubric'
        if c.save
          puts "saved seo ##{c.id}"
        else
          puts "cannot save seo ##{c.id}"
          p c.errors
        end 
      end
    end
    unused = Seo.where('path is null or path = ""').select{|s|s.seo.nil?}
    puts "unused - #{unused.count}"
    unused.each(&:destroy)
  end
end






































