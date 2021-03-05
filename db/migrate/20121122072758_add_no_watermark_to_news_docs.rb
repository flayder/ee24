class AddNoWatermarkToNewsDocs < ActiveRecord::Migration
  def change
    add_column :news_docs, :no_watermark, :boolean, :default => false
  end
end
