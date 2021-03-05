class CreateAdCodes < ActiveRecord::Migration
  def change
    create_table :ad_codes do |t|
      t.text :code, :default => ''
      t.integer :ad_section_id
      t.string :ad_section_type
      t.integer :site_id
      t.string :url
      t.string :banner_type

      t.timestamps
    end
    add_index :ad_codes, [:ad_section_id, :ad_section_type]
    add_index :ad_codes, :site_id
  end
end
