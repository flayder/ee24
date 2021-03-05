class AddLongImageToDocs < ActiveRecord::Migration
  def change
    add_column :docs, :long_image, :boolean, default: false
  end
end
