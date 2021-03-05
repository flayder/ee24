class AddPostedAtToVacancies < ActiveRecord::Migration
  def change
    add_column :vacancies, :posted_at, :datetime

    Vacancy.all.each {|v| v.update_attributes(posted_at: v.created_at + 30.days)}
  end
end
