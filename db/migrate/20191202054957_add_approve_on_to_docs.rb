class AddApproveOnToDocs < ActiveRecord::Migration
  def change
    add_column :docs, :approve_on, :datetime
  end
end
