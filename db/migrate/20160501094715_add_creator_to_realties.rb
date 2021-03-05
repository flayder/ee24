class AddCreatorToRealties < ActiveRecord::Migration
  def change
    add_column :realties, :creator_id, :integer
  end
end
