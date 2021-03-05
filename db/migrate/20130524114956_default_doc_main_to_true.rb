class DefaultDocMainToTrue < ActiveRecord::Migration
  def change
    change_column_default :docs, :main, true
  end
end
