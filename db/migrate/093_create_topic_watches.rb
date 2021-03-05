class CreateTopicWatches < ActiveRecord::Migration
  def self.up
    create_table :topic_watches do |t|
      t.column :user_id,                    :integer
      t.column :topic_id,                   :integer
      t.column :forum_id,                   :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :topic_watches
  end
end
