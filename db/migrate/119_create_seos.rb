class CreateSeos < ActiveRecord::Migration
  def self.up
    create_table :seos, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.text      "about"

      t.string    "title"
      t.text      "description"
      t.text      "keywords"

      t.integer   "seo_id"
      t.string    "seo_type"

      t.integer   "city_id"
      t.timestamps
    end
  end

  def self.down
    drop_table :seos
  end
end
