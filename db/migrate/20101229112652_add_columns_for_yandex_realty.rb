class AddColumnsForYandexRealty < ActiveRecord::Migration
  def self.up
    change_table(:boards) do |t|
      t.string  :country
      t.string  :region
      t.string  :district
      t.string  :locality_name
      t.boolean :for_yandex_realty
      t.boolean :is_urban, :default => true
      t.string :address
    end
  end

  def self.down
    change_table(:boards) do |t|
      t.remove  :country
      t.remove  :region
      t.remove  :district
      t.remove  :locality_name

      t.remove :for_yandex_realty
      t.remove :is_urban
      t.remove :address
    end
  end
end
