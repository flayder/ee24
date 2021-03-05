class DeleteOldGenderFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :gender
    rename_column :users, :new_gender, :male
  end
end
