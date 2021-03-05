class RemoveContests < ActiveRecord::Migration
  def up
    drop_table :contests
    drop_table :contests_winners
    drop_table :contest_parts
    drop_table :contest_part_photos
  end

  def down
    create_table :contests do |t|
      t.string :title, :sponsor_image, :prize_title, :prize_image
      t.datetime :start, :finish
      t.integer :topic_id
      t.text :card_text
      t.integer :part_photos_count, :default => 0, :null => false
      t.boolean :part_text, :default => false
      t.timestamps
    end
    add_index :contests, :topic_id

    create_table :contests_winners, :id => false do |t|
      t.integer :contest_id
      t.integer :user_id
    end

    create_table :contest_parts do |t|
      t.integer :contest_id
      t.integer :user_id
      t.text :text, :default => '', :null => false
      t.timestamps
    end
    add_index :contest_parts, :contest_id
    add_index :contest_parts, :user_id

    create_table :contest_part_photos do |t|
      t.string :image, :default => ''
      t.integer :contest_part_id

      t.timestamps
    end
    add_index :contest_part_photos, :contest_part_id
  end
end
