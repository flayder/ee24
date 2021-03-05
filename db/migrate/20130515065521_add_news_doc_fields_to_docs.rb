class AddNewsDocFieldsToDocs < ActiveRecord::Migration
  def change
    add_column :docs, :no_watermark, :boolean, default: false
    add_column :docs, :search, :string
    add_column :docs, :pictureless, :boolean, default: false
    add_column :docs, :news_doc_doc_id, :integer
    add_column :docs, :news_doc_id, :integer

    add_index :docs, :news_doc_id
    add_index :docs, :news_doc_doc_id
  end
end
