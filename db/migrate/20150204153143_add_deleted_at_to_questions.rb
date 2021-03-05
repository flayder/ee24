class AddDeletedAtToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :deleted_at, :datetime
    add_index :questions, :deleted_at
  end
end
