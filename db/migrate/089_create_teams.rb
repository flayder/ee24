class CreateTeams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.column :title,                    :string
      t.column :position,               :integer
      t.column :vstrechi,               :integer
      t.column :ochki,                   :integer
      t.column :npcl_group,            :string
      t.timestamps
    end
  end

  def self.down
    drop_table :teams
  end
end
