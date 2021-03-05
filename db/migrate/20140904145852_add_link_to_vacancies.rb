class AddLinkToVacancies < ActiveRecord::Migration
  def change
    add_column :vacancies, :link, :string, default: ''
  end
end
