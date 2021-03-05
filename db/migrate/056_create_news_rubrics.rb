class CreateNewsRubrics < ActiveRecord::Migration
  def self.up
    create_table :news_rubrics do |t|
      t.column :title,            :string
      t.column :link,             :string
      t.column :main,             :boolean
      t.column :active,           :boolean
      t.timestamps
    end
  end

  def self.down
    drop_table :news_rubrics
  end
end
