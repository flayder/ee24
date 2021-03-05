class CreateAtmCardTypes < ActiveRecord::Migration
  def change
    create_table :atm_card_types do |t|
      t.integer :atm_id
      t.integer :bank_card_type_id

      t.timestamps
    end
    add_index :atm_card_types, :atm_id
    add_index :atm_card_types, :bank_card_type_id
  end
end
