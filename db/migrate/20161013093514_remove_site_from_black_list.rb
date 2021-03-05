class RemoveSiteFromBlackList < ActiveRecord::Migration
  SITE_ID = Site.find_by_domain('420on.cz').id
  def up
    if column_exists? :black_list_words, :site_id
      BlackListWord.where('site_id != ?', SITE_ID).destroy_all
      remove_column :black_list_words, :site_id
    end
  end

  def down
    add_column :black_list_words, :site_id, :integer, default: SITE_ID unless column_exists? :black_list_words, :site_id
  end
end
