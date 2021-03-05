class DeleteSiteDictionaries < ActiveRecord::Migration
  def change
    remove_index :site_dictionaries, :site_id
    remove_index :site_dictionaries, [:site_id, :dictionary_type]
    drop_table :site_dictionaries
  end
end