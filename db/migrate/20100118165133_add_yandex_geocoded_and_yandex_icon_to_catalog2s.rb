class AddYandexGeocodedAndYandexIconToCatalog2s < ActiveRecord::Migration
  def self.up
    add_column :catalog2s, :yandex_geocoded, :boolean, :default => false
    add_column :catalog2s, :yandex_icon, :string
  end

  def self.down
    remove_column :catalog2s, :yandex_icon
    remove_column :catalog2s, :yandex_geocoded
  end
end
