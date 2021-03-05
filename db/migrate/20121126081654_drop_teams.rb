class DropTeams < ActiveRecord::Migration
  def up
    drop_table :teams
  end

  def down
    create_table :teams do |t|
      t.string   :title
      t.integer  :position
      t.integer  :vstrechi
      t.integer  :ochki
      t.string   :npcl_group
      t.datetime :created_at
      t.datetime :updated_at
    end
  end
end
