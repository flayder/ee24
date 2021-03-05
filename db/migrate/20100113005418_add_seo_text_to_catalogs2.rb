class AddSeoTextToCatalogs2 < ActiveRecord::Migration
  def self.up
    add_column :catalog2s, :seo_text, :text
  end

  def self.down
    remove_column :catalog2s, :seo_text
  end
end
