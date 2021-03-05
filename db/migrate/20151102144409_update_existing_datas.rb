class UpdateExistingDatas < ActiveRecord::Migration
  def up
    say "migrate existing data..."
    bar = ProgressBar.new(Catalog.count)
    CatalogDescription.skip_callback(:save, :after, :update_rubrics_counter)
    Catalog.skip_callback(:save, :after, :update_rubrics_counter)
    Catalog.all.each do |catalog|
      bar.increment!
      catalog.catalog_descriptions.create(language: 'ru',
                                          title: catalog.read_attribute(:title),
                                          annotation: catalog.read_attribute(:annotation),
                                          text: catalog.read_attribute(:text))
    end
    CatalogDescription.set_callback(:save, :after, :update_rubrics_counter)
    Catalog.set_callback(:save, :after, :update_rubrics_counter)

    remove_column :catalogs, :title
    remove_column :catalogs, :annotation
    remove_column :catalogs, :text

    bar2 = ProgressBar.new(CatalogRubric.count)
    CatalogRubric.all.each do |rubric|
      bar2.increment!
      rubric.update_attribute(:english_title, Russian::translit(rubric.title))
    end

    bar3 = ProgressBar.new(CatalogRubric.site(93).count)
    CatalogRubric.site(93).all.each do |catalog_rubric|
      catalog_rubric.update_counters
      bar3.increment!
    end
    remove_column :catalog_rubrics, :counter
  end

  def down
    add_column :catalogs, :title, :string
    add_column :catalogs, :annotation, :text
    add_column :catalogs, :text, :text

    say "migrate existing data..."
    bar = ProgressBar.new(Catalog.count)
    Catalog.all.each do |catalog|
      bar.increment!
      catalog_description = catalog.catalog_descriptions.by_language('ru').first
      if catalog_description.present?
        catalog.update_column(:title, catalog_description.title)
        catalog.update_column(:annotation, catalog_description.annotation)
        catalog.update_column(:text, catalog_description.text)
      end
    end

    add_column :catalog_rubrics, :counter, :integer
    bar2 = ProgressBar.new(CatalogRubric.site(93).count)
    CatalogRubric.site(93).all.each do |catalog_rubric|
      catalog_rubric.update_column(:counter, catalog_rubric.counter(:ru))
      bar2.increment!
    end
  end
end
