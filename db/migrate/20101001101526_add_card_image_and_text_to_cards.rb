#доп. текст и картинка для партнёров и текст для конкурсов
class AddCardImageAndTextToCards < ActiveRecord::Migration
  def self.up
    add_column :partners, :card_image, :string
    add_column :partners, :card_text, :text
    add_column :contests, :card_text, :text
  end

  def self.down
    remove_column :partners, :card_image
    remove_column :partners, :card_text
    remove_column :contests, :card_text
  end
end
