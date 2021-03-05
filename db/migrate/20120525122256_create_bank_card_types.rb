class CreateBankCardTypes < ActiveRecord::Migration
  def change
    create_table :bank_card_types do |t|
      t.string :title, :default => ''
      t.string :image, :default => ''

      t.timestamps
    end
  end
end
