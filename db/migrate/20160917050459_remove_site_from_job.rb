class RemoveSiteFromJob < ActiveRecord::Migration
  SITE_ID = Site.find_by_domain('420on.cz').id
  def up
    if column_exists? :vacancies, :site_id
      Vacancy.where('site_id != ?', SITE_ID).delete_all
      remove_column :vacancies, :site_id
    end
    if column_exists? :resumes, :site_id
      Resume.where('site_id != ?', SITE_ID).delete_all
      remove_column :resumes, :site_id
    end
    if column_exists? :industries, :site_id
      Industry.where('site_id != ?', SITE_ID).delete_all
      remove_column :industries, :site_id
    end
    if column_exists? :professions, :site_id
      Profession.where('site_id != ?', SITE_ID).delete_all
      remove_column :professions, :site_id
    end
  end

  def down
    add_column :vacancies, :site_id, :integer, default: SITE_ID unless column_exists? :vacancies, :site_id
    add_column :resumes, :site_id, :integer, default: SITE_ID unless column_exists? :resumes, :site_id
    add_column :industries, :site_id, :integer, default: SITE_ID unless column_exists? :professions, :site_id
    add_column :professions, :site_id, :integer, default: SITE_ID unless column_exists? :professions, :site_id
  end
end
