class AddPhotoToExternalDoc < ActiveRecord::Migration
  def change
    add_column :external_docs, :image, :string
  end
end
