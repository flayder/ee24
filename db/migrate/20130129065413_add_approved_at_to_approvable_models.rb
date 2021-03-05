class AddApprovedAtToApprovableModels < ActiveRecord::Migration
  def change
    add_column :boards, :approved_at, :datetime
    add_column :catalog2s, :approved_at, :datetime
    add_column :galleries, :approved_at, :datetime
    add_column :resumes, :approved_at, :datetime
    add_column :vacancies, :approved_at, :datetime
    add_column :news_docs, :approved_at, :datetime
    add_column :events, :approved_at, :datetime
    add_column :comments, :approved_at, :datetime
    add_column :docs, :approved_at, :datetime
  end
end
