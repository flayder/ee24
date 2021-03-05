class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.column :title,            :string
      t.column :annotation,       :text
      t.column :text,             :text
      t.column :image,            :string
      t.column :adress,           :text
      t.column :place_id,         :integer
      t.column :event_rubric_id,  :integer
      t.column :main,             :boolean
      t.column :active,           :boolean
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
