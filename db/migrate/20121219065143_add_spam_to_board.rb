class AddSpamToBoard < ActiveRecord::Migration
  def change
    add_column :boards, :spam, :boolean
  end
end
