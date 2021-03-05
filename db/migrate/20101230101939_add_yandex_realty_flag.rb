class AddYandexRealtyFlag < ActiveRecord::Migration
  def self.up
    add_column :board_types, :for_yandex_realty, :boolean, :default => false
    add_column :board_rubrics, :for_yandex_realty, :boolean, :default => false
  end

  def self.down
    remove_columm :board_types, :for_yandex_realty
    remove_columm :board_rubrics, :for_yandex_realty
  end
end
