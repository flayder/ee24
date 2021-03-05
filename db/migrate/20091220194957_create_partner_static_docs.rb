class CreatePartnerStaticDocs < ActiveRecord::Migration
  def self.up
    create_table :partner_static_docs do |t|
      t.integer :partner_id
      t.string :title
      t.text :text
      t.string :param
      t.boolean :important
      t.boolean :published
      t.integer :position
      t.timestamps
    end
  end

  def self.down
    drop_table :partner_static_docs
  end
end
