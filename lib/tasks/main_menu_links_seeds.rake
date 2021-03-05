namespace :main_menu_links do
  task seed: :environment do
    Site.active.each do |site|
      site.sections.includes(:site_sections).
        where(site_sections: { site_id: site.id }).order('position').
        where('controller not in ("docs", "map", "weather", "dictionary_objects", "search", "comments", "admin/external_docs", "forecast/locations")').
        each do |section|
          next if section.title.blank?
          next if section.controller.blank?

          site.main_menu_links.find_or_create_by_path("/#{section.controller}") do |link|
            link.title = section.title
            link.position = section.position
          end
      end

      site.doc_global_rubrics.each do |rubric|
        next if rubric.title.blank?
        next if rubric.link.blank?

        site.main_menu_links.find_or_create_by_path("/#{rubric.link}") do |link|
          link.title = rubric.title
        end
      end
    end
  end
end
