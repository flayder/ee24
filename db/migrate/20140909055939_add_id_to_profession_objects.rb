class AddIdToProfessionObjects < ActiveRecord::Migration
  def change
    add_column :profession_objects, :id, :primary_key
  end
end
