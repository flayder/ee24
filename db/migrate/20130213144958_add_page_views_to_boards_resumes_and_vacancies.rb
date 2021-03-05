class AddPageViewsToBoardsResumesAndVacancies < ActiveRecord::Migration
  def change
    add_column :boards, :page_views, :integer, :default => 1
    add_column :resumes, :page_views, :integer, :default => 1
    add_column :vacancies, :page_views, :integer, :default => 1
  end
end
