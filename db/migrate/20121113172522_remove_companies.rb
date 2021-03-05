class RemoveCompanies < ActiveRecord::Migration
  def up
    drop_table :companies
    remove_column :boards, :company_id
    remove_column :vacancies, :company_id
  end

  def down
    create_table :companies do |t|
      t.integer :user_id
      t.string :title
      t.string :site
      t.string :logo
      t.text :about

      t.timestamps
    end

    add_column :boards, :company_id, :integer
    add_index :boards, :company_id

    add_column :vacancies, :company_id, :integer
    add_index :vacancies, :company_id
  end

end
