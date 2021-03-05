# encoding:utf-8

namespace :photo_rubrics do
  task :destroy_old => :environment do
    rubrics = PhotoRubric.where('parent_id is not null')
    rubrics.each(&:destroy)
  end

  task :positions => :environment do
    i = 0
    ['news', 'magazine', 'travel', 'voronezh', 'cybersport'].each do |link|
      rubric = PhotoRubric.site(1).find_by_link(link)
      rubric.position = i
      rubric.save
      i += 1
    end
  end
end

