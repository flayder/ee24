class RemoveErrorPageCountAndActiveAndDomainFromCities < ActiveRecord::Migration
  def change
    remove_column :cities, :error_page_count
    remove_column :cities, :domain
    remove_column :cities, :active
  end
end