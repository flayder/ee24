class AddLogoToBanks < ActiveRecord::Migration
  def change
    add_column :banks, :logo, :string
  end
end
