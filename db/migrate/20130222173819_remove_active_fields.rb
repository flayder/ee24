class RemoveActiveFields < ActiveRecord::Migration
  def up
    [:boards, :catalog_global_rubrics, :catalogs, :docs, :event_rubrics, :events, :industries, :news_docs, :news_rubrics, :professions].each do |t|
      remove_column t, :active
    end
  end

  def down
    [:boards, :catalog_global_rubrics, :catalogs, :docs, :event_rubrics, :events, :industries, :news_docs, :news_rubrics, :professions].each do |t|
      add_column t, :active, :boolean, :default => true
    end
  end
end
