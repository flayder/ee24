class AddNotOnMainFlagToGalleries < ActiveRecord::Migration
  def change
    add_column :galleries, :not_on_main, :boolean, :default => false
  end
end
