class RemoveSiteFormPhoto < ActiveRecord::Migration
  SITE_ID = Site.find_by_domain('420on.cz').id
  def up
    if column_exists? :photos, :site_id
      Photo.where('site_id != ?', SITE_ID).destroy_all
      remove_column :photos, :site_id
    end
  end

  def down
    add_column :photos, :site_id, :integer, default: SITE_ID unless column_exists? :photos, :site_id
  end
end
