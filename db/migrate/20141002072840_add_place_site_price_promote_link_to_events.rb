class AddPlaceSitePricePromoteLinkToEvents < ActiveRecord::Migration
  def change
    add_column :events, :place, :string
    add_column :events, :site_url, :string
    add_column :events, :price, :string
    add_column :events, :promote_link, :string
    add_column :events, :show_time, :boolean, default: false
  end
end
