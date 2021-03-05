class AddSeoColumnsToDoc < ActiveRecord::Migration
  def self.up
    change_table(:docs) do |t|
      t.text :meta_title, :default => ''
      t.text :meta_keywords, :default => ''
      t.text :meta_description, :default => ''
      t.text :about, :default => ''
      t.text :seo_text, :default => ''
    end
  end

  def self.down
    change_table(:docs) do |t|
      t.remove :meta_title
      t.remove :meta_keywords
      t.remove :meta_description
      t.remove :about
      t.remove :seo_text
    end
  end
end
