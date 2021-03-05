class CreateWebAnalyticsBlocks < ActiveRecord::Migration
  def change
    create_table :web_analytics_blocks do |t|
      t.text :body
      t.integer :site_id, :uniq => true

      t.timestamps
    end
  end
end