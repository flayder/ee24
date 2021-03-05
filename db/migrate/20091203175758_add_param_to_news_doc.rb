class AddParamToNewsDoc < ActiveRecord::Migration
  def self.up
    add_column :news_docs, :param, :string
  end

  def self.down
    remove_column :news_docs, :param
  end
end
