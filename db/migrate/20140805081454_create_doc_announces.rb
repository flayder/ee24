class CreateDocAnnounces < ActiveRecord::Migration
  def change
    create_table :doc_announces do |t|
      t.string :image
      t.string :url

      t.timestamps
    end
  end
end
