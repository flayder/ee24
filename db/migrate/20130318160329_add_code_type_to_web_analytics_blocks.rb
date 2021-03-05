class AddCodeTypeToWebAnalyticsBlocks < ActiveRecord::Migration
  def change
    add_column :web_analytics_blocks, :code_type, :string, :default => ''
  end
end
