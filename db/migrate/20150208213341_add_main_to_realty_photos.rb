class AddMainToRealtyPhotos < ActiveRecord::Migration
  def change
    add_column :realty_photos, :main, :boolean
  end
end
