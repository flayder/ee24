class AddWithCityToSection < ActiveRecord::Migration
  def change
    add_column :sections, :with_city, :boolean, :default => false
  end
end
