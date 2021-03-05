class AddBankIdAndNoteToAtms < ActiveRecord::Migration
  def up
    change_table(:atms) do |t|
      t.integer :bank_id
      t.string :note, :default => ''
    end
    add_index :atms, :bank_id
  end

  def down
    change_table(:atms) do |t|
      t.remove :bank_id
      t.remove :note
    end
  end
end
