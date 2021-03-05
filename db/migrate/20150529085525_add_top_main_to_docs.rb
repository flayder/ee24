class AddTopMainToDocs < ActiveRecord::Migration
  def change
    add_column :docs, :top_main, :boolean, default: false
  end
end
