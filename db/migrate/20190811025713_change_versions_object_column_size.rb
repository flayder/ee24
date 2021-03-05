class ChangeVersionsObjectColumnSize < ActiveRecord::Migration
  def change
    change_column :versions, :object, :text, limit: 1_073_741_823
  end
end
