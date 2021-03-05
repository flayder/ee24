class AddPostedForToVacancies < ActiveRecord::Migration
  def change
    add_column :vacancies, :posted_for, :integer, default: 30
  end
end
