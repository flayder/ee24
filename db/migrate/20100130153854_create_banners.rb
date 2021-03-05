class CreateBanners < ActiveRecord::Migration
  def self.up
    create_table :banners do |t|
      t.string :title, :nil => false
      t.date :start_date, :nil => false
      t.date :finish_date, :nil => false
      t.string :controller, :nil => false
      t.integer :counter, :nil => false, :default => 0
      t.string :image, :nil => false
      t.timestamps
    end
  end

  def self.down
    drop_table :banners
  end
end