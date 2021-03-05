class AddFieldsToVacancies < ActiveRecord::Migration
  def change
    add_column :vacancies, :region_city_id, :integer
    add_column :vacancies, :catalog_id, :integer
    add_index :vacancies, :region_city_id
    add_index :vacancies, :catalog_id
  end
end
