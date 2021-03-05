class AddPublishedToTopInfos < ActiveRecord::Migration
  def self.up
    add_column :partner_top_infos, :published, :boolean
  end

  def self.down
    remove_column :partner_top_infos, :published
  end
end
