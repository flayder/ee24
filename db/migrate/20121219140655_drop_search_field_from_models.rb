class DropSearchFieldFromModels < ActiveRecord::Migration
  def change
    remove_column :docs, :search
    remove_column :events, :search
  end
end