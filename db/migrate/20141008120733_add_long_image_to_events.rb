class AddLongImageToEvents < ActiveRecord::Migration
  def change
    add_column :events, :long_image, :boolean, default: false
  end
end
