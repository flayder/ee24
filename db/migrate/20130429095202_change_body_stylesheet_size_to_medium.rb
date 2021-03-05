class ChangeBodyStylesheetSizeToMedium < ActiveRecord::Migration
  def change
    change_column :design_stylesheets, :body, :text, :limit => 16777215
  end
end
