class AddNewFieldsToVacancies < ActiveRecord::Migration
  def change
    add_column :vacancies, :currency, :integer
    add_column :vacancies, :description, :text
    add_column :vacancies, :terms, :text
    add_column :vacancies, :requirements, :text
    add_column :vacancies, :hot, :boolean, default: false
    add_column :vacancies, :additional_info, :text
    add_column :vacancies, :user_contacts, :boolean, default: false
    add_column :vacancies, :contacts_name, :string
    add_column :vacancies, :contacts_email, :string
    add_column :vacancies, :contacts_phone, :string
  end
end
