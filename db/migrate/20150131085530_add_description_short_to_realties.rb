class AddDescriptionShortToRealties < ActiveRecord::Migration
  def change
    add_column :realties, :description_short, :text
  end
end
