class RemoveUrlPictureFromExternalDocs < ActiveRecord::Migration
  def up
    remove_column :external_docs, :url_picture
  end

  def down
    add_column :external_docs, :url_picture, :string
  end
end
