class CreateSharedPhotos < ActiveRecord::Migration
  def up
    create_table "shared_photos" do |t|
      t.integer  :doc_id
      t.string   :doc_type
      t.string   :image
      t.string  :main_photo_url
      t.timestamps
    end
  end

  def down
    drop_table :shared_photos
  end
end
