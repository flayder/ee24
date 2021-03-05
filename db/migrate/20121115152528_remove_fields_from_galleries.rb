class RemoveFieldsFromGalleries < ActiveRecord::Migration
  def up
    change_table(:galleries) do |t|
      t.remove :main
      t.remove :active
      t.remove :on_main
      t.remove :on_main_2
      t.remove :place
      t.remove :user_id
      t.remove :user_fio
      t.remove :user_about
      t.remove :upload
      t.remove :run_upload
      t.remove :position
      t.remove :link
    end
  end

  def down
    change_table(:galleries) do |t|
      t.boolean :main
      t.boolean :active
      t.boolean :on_main
      t.boolean :on_main_2
      t.string  :place
      t.integer :user_id
      t.string  :user_fio
      t.string  :user_about
      t.string  :upload
      t.boolean :run_upload
      t.integer :position
      t.string  :link
    end
  end
end
