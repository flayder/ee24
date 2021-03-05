class AddCommentationAtGallery < ActiveRecord::Migration
  def self.up
    add_column( "galleries", "commentation", :boolean, :default => true )
  end

  def self.down
    remove_column("galleries", "commentation")
  end
end
