class DropDreamsMeteoInfosAndAstroStars < ActiveRecord::Migration
  def change
    drop_table :dreams
    drop_table :astrostars
    drop_table :meteoinfos
  end
end
