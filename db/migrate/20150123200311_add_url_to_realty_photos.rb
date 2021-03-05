class AddUrlToRealtyPhotos < ActiveRecord::Migration
  def change
    add_column :realty_photos, :url, :string
  end
end
