class AddSiteIdToIndustryAndProfession < ActiveRecord::Migration
  def change
    add_column :industries, :site_id, :integer
    add_column :professions, :site_id, :integer
    add_column :industries, :old_id, :integer
    add_column :professions, :old_id, :integer

    Industry.update_all(site_id: 1)
    Profession.update_all(site_id: 1)
  end
end
