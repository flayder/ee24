class CreateEventRubrics < ActiveRecord::Migration
  def self.up
    create_table :event_rubrics do |t|
      t.column :title,            :string
      t.column :image,            :string
      t.column :link,             :string
      t.column :main,             :boolean
      t.column :active,           :boolean
      t.timestamps
    end
  end

  def self.down
    drop_table :event_rubrics
  end
end
