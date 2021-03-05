class AddGmapAnnotationAtPlaces < ActiveRecord::Migration
  def self.up
    add_column("places", "gmap_annotation",  :text)
  end

  def self.down
    remove_column("places", "gmap_annotation")
  end
end
