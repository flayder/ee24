class AddNoWatermarkToGalleries < ActiveRecord::Migration
  def self.up
    add_column :galleries, :no_watermark, :boolean, :default => false
  end

  def self.down
    remove_column :galleries, :no_watermark
  end
end
