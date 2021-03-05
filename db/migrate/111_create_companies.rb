class CreateCompanies < ActiveRecord::Migration
  def self.up
    create_table :companies, :options => 'ENGINE=InnoDB DEFAULT CHARSET=utf8' do |t|
      t.column :user_id,                    :integer
      t.column :title,                      :string
      t.column :site,                       :string
      t.column :logo,                       :string
      t.column :about,                      :text
      t.timestamps
    end
  end

  def self.down
    drop_table :companies
  end
end
