class DefaultConfirmForUsers < ActiveRecord::Migration
  def change
    change_column_default :users, :confirm, false
  end
end
