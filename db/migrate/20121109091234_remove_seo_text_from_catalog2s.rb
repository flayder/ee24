class RemoveSeoTextFromCatalog2s < ActiveRecord::Migration
  def change
    remove_column :catalog2s, :seo_text
  end
end
