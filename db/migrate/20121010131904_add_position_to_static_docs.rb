class AddPositionToStaticDocs < ActiveRecord::Migration
  def change
    add_column :static_docs, :position, :integer
  end
end
