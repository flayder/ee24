class AddMainBannerToEventRubrics < ActiveRecord::Migration
  def change
    add_column :event_rubrics, :main_banner, :text
  end
end
