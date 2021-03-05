class CreateSocialWidgetCodes < ActiveRecord::Migration
  def change
    create_table :social_widget_codes do |t|
      t.string :widget_type, :default => ''
      t.text :code, :default => ''
      t.integer :site_id

      t.timestamps
    end
  end
end
