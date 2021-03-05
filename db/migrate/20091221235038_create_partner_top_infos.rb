class CreatePartnerTopInfos < ActiveRecord::Migration
  def self.up
    create_table :partner_top_infos do |t|
      t.integer :partner_id
      t.string :title
      t.string :link
      t.string :image
      t.timestamps
    end
  end

  def self.down
    drop_table :partner_top_infos
  end
end
