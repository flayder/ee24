class AddBackgroundAndBackgroundLinkToSites < ActiveRecord::Migration
  def change
    add_column :sites, :background, :string
    add_column :sites, :background_link, :string
  end
end
