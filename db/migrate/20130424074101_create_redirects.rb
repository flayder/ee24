class CreateRedirects < ActiveRecord::Migration
  def change
    create_table :redirects do |t|
      t.string :from
      t.string :to
      t.integer :site_id

      t.timestamps
    end

    add_index :redirects, :from
    add_index :redirects, :site_id
  end
end
