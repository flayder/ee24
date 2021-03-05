class CreateNews < ActiveRecord::Migration
  def self.up
    create_table :news do |t|
      t.column :title,            :string
      t.column :text,             :text
      t.column :main,             :boolean
      t.column :active,           :boolean
      t.column :city,             :boolean
      t.column :news_rubric_id,   :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :news
  end
end
