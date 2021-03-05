class CreateNewsDocs < ActiveRecord::Migration
  def self.up
    create_table :news_docs do |t|
      t.column :title,            :string
      t.column :annotation,       :text
      t.column :text,             :text
      t.column :image,            :string
      t.column :main,             :boolean
      t.column :active,           :boolean
      t.column :city,             :boolean
      t.column :news_rubric_id,   :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :news_docs
  end
end
