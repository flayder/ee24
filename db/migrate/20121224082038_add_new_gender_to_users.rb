class AddNewGenderToUsers < ActiveRecord::Migration
  def change
    add_column :users, :new_gender, :boolean
  end
end
