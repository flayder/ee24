class ChangeFromCityIdToSiteIdJob < ActiveRecord::Migration
  def up
    rename_column :vacancies, :city_id, :site_id
    rename_column :resumes, :city_id, :site_id
  end

  def down
    rename_column :vacancies, :site_id, :city_id
    rename_column :resumes, :site_id, :city_id
  end
end
