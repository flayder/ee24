class ChangeColumnMainInDocs < ActiveRecord::Migration
  def up
    change_column_default(:docs, :main, true)
  end

  def down
    change_column_default(:docs, :main, false)
  end
end
