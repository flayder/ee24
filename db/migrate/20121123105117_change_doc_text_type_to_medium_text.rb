class ChangeDocTextTypeToMediumText < ActiveRecord::Migration
  def change
    change_column :docs, :text, :text, :limit => 16777215
  end
end
