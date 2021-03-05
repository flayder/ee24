class AddHeroQuoteToDocs < ActiveRecord::Migration
  def change
    add_column :docs, :hero, :string
    add_column :docs, :quote, :string
  end
end
