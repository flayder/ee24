class AddApprovedAtToExternalDocs < ActiveRecord::Migration
  def change
    add_column :external_docs, :approved_at, :datetime
  end
end
