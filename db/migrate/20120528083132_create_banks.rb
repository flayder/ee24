class CreateBanks < ActiveRecord::Migration
  def change
    create_table :banks do |t|
      t.string :title, :default => ''
      t.timestamps
    end
  end
end
