class AddRegionIdToVacancies < ActiveRecord::Migration
  def change
    add_column :vacancies, :region_id, :integer
    add_index :vacancies, :region_id
  end
end
