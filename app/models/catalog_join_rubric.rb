class CatalogJoinRubric < ActiveRecord::Base
  belongs_to :catalog_rubric
  belongs_to :catalog

  after_save    :update_counts_for_rubrics
  after_touch   :update_counts_for_rubrics

  private

  def update_counts_for_rubrics
    catalog.catalog_descriptions.where("title <> ''").each do |description|
      catalog_rubric.self_and_ancestors.each do |rubric|
        catalog_rubric_counter = rubric.catalog_rubric_counters.where(language: description.language.to_s).first ||
            rubric.catalog_rubric_counters.create(language: description.language.to_s)
        counter = if rubric.catalogs.present?
                    rubric.catalogs.approved.site(rubric.site).by_language(description.language).count
                  else
                    rubric.descendants.flat_map{|rubric| rubric.catalogs.approved.by_language(description.language)}.uniq.count
                  end
        catalog_rubric_counter.update_column(:counter, counter)
      end
    end
    catalog.touch
  end
end
