class AddRentalToRealty < ActiveRecord::Migration
  def change
    add_column :realties, :realty_for, :string, default: 'sale'
  end
end
