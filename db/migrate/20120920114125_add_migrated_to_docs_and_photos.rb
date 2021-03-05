class AddMigratedToDocsAndPhotos < ActiveRecord::Migration
  def change
    add_column :docs, :migrated, :boolean, :default => false
    add_column :news_docs, :migrated, :boolean, :default => false
    add_column :events, :migrated, :boolean, :default => false
    add_column :photos, :migrated, :boolean, :default => false
  end
end
