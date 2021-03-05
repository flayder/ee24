class RemoveTwitter < ActiveRecord::Migration
  def up
    remove_column :doc_rubrics, :twitter
  end

  def down
    add_column :doc_rubrics, :twitter, :boolean, default: false
  end
end
