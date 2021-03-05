class AddAnnotationCardAtGalleries < ActiveRecord::Migration
  def self.up
    add_column("galleries", "annotation_card", :text)
  end

  def self.down
    remove_column("galleries", "annotation_card")
  end
end
