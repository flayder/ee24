# encoding:utf-8
class CreateAdFormats < ActiveRecord::Migration
  def change
    create_table :ad_formats do |t|
      t.string :title, :default => ''
      t.timestamps
    end
  end
end
