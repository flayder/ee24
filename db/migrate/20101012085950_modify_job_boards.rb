class ModifyJobBoards < ActiveRecord::Migration
  def self.up
    remove_column :vacancies, :active
    remove_column :vacancies, :main
    remove_column :vacancies, :email
    remove_column :vacancies, :tel
    remove_column :vacancies, :name
    remove_column :vacancies, :photo_1
    rename_column :vacancies, :company, :company_name

    remove_column :resumes, :active
    remove_column :resumes, :main
    remove_column :resumes, :email
    remove_column :resumes, :tel
    remove_column :resumes, :name
    remove_column :resumes, :photo_1

    add_index :vacancies, :city_id
    add_index :vacancies, :industry_id
    add_index :vacancies, :user_id
    add_index :vacancies, :company_id

    add_index :resumes, :city_id
    add_index :resumes, :industry_id
    add_index :resumes, :user_id

    add_index :professions, :industry_id

    add_column :vacancies, :approved, :boolean, :default => false
    add_column :resumes, :approved, :boolean, :default => false
  end

  def self.down
    add_column :vacancies, :active, :boolean
    add_column :vacancies, :main, :boolean
    add_column :vacancies, :email, :string
    add_column :vacancies, :tel, :string
    add_column :vacancies, :name, :string
    add_column :vacancies, :photo_1, :string
    rename_column :vacancies, :company_name, :company

    add_column :resumes, :active, :boolean
    add_column :resumes, :main, :boolean
    add_column :resumes, :email, :string
    add_column :resumes, :tel, :string
    add_column :resumes, :name, :string
    add_column :resumes, :photo_1, :string

    remove_index :vacancies, :city_id
    remove_index :vacancies, :industry_id
    remove_index :vacancies, :user_id
    remove_index :vacancies, :company_id

    remove_index :resumes, :city_id
    remove_index :resumes, :industry_id
    remove_index :resumes, :user_id

    remove_index :professions, :industry_id

    remove_column :vacancies, :approved
    remove_column :resumes, :approved
  end
end
