# encoding:utf-8
namespace :job do
  task migrate: :environment do
    sites = Site.joins(:site_sections).where('sites.domain != ?', '36on.ru').where('site_sections.section_id = ?', Section.find_by_controller('job').id).active


    sites.each do |site|
      Site.voronezh.industries.each do |industry|
        new_industry = industry.dup
        new_industry.site = site
        new_industry.old_id = industry.id
        new_industry.save!

        site.resumes.where(industry_id: industry.id).update_all(industry_id: new_industry.id)
        site.vacancies.where(industry_id: industry.id).update_all(industry_id: new_industry.id)

        industry.professions.each do |profession|
          new_profession = profession.dup
          new_profession.old_id = profession.id
          new_profession.industry = new_industry
          new_profession.site = site
          new_profession.save!

          ProfessionObject.where(resume_id: site.resumes.pluck(:id)).update_all(profession_id: new_profession.id)
          ProfessionObject.where(vacancy_id: site.vacancies.pluck(:id)).update_all(profession_id: new_profession.id)
        end
      end
    end
  end

  task professions: :environment do
    Industry.all.each(&:destroy)
    is_industry = true
    site = Site.prague
    File.readlines("#{Rails.root}/config/professions.txt").each do |line|
      #создаём отрасль
      if is_industry
        @industry = site.industries.new({title: line.strip}, as: :admin)
        if @industry.save 
          puts "Created industry - #{line}"
          is_industry = false
        else
          puts "Could not create industry - #{line}"
          exit
        end
      elsif line == "\n"
        is_industry = true
      else
        #создаём профессии в отрасли
        profession = @industry.professions.new({title: line.strip}, as: :admin)
        profession.site = site
        if profession.save
          puts "Created profession - #{line}"
        else
          puts "Could not create profession - #{line}"
        end
      end
    end
  end
end
