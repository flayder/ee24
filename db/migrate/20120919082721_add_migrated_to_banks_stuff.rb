class AddMigratedToBanksStuff < ActiveRecord::Migration
  def change
  	add_column :banks, :migrated, :boolean, :default => false
  	add_column :bank_card_types, :migrated, :boolean, :default => false
  end
end
