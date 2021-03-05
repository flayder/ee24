class AddWatermarkToSites < ActiveRecord::Migration
  def change
    add_column :sites, :watermark, :string
  end
end
