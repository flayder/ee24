class AddClosedToVacancies < ActiveRecord::Migration
  def change
    add_column :vacancies, :closed, :boolean, default: false
  end
end
