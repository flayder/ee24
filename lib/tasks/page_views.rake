namespace :page_views do
  task update: :environment do
    PageViewsUpdater.update_async
  end

  task :export => :environment do
    MODELS = [Catalog, Doc, Event, Gallery, Resume, Vacancy]

    file = File.open('page_view_stats', 'w')

    MODELS.each do |model|
      model.find_each do |obj|
        file.write("#{model}:#{obj.id}:#{obj.page_views}\n")
      end
    end

    file.close
  end

  task import: :environment do
    file = File.read('page_view_stats')
    data = file.split("\n").map { |row| row.split(':') }

    data.each do |model, id, page_views|
      obj = model.constantize.find_by_id(id)

      next unless obj
      next if obj.page_views.to_i > page_views.to_i

      obj.update_column(:page_views, page_views.to_i + rand(200))
    end
  end
end
