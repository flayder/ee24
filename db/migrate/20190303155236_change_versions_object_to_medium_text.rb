class ChangeVersionsObjectToMediumText < ActiveRecord::Migration
  def change
    change_column :versions, :object_changes, :text, limit: 1_073_741_823
  end
end
