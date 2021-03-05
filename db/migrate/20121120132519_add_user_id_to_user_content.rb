class AddUserIdToUserContent < ActiveRecord::Migration
  def change
    add_column :catalog2s, :user_id, :integer
    add_column :docs, :user_id, :integer
    add_column :news_docs, :user_id, :integer
    add_column :galleries, :user_id, :integer
    add_column :events, :user_id, :integer

    add_index :catalog2s, :user_id
    add_index :docs, :user_id
    add_index :news_docs, :user_id
    add_index :galleries, :user_id
    add_index :events, :user_id
  end
end
