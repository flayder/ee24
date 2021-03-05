class AddNewsKeywordsToSeos < ActiveRecord::Migration
  def change
    add_column :seos, :news_keywords, :string
  end
end
