class AddPremoderationToForums < ActiveRecord::Migration
  def change
    add_column :forums, :premoderation, :boolean, default: true
  end
end
