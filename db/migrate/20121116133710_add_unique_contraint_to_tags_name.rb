class AddUniqueContraintToTagsName < ActiveRecord::Migration
  def change
    add_index :tags, [:name, :site_id], :unique => true
  end
end