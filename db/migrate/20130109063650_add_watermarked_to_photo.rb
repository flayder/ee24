class AddWatermarkedToPhoto < ActiveRecord::Migration
  def change
    add_column :photos, :watermarked, :boolean, :default => false
  end
end
