class CreateBoards < ActiveRecord::Migration
  def self.up
    create_table :boards do |t|
      t.column :user_id,                      :integer
      t.column :board_rubric_id,              :integer
      t.column :city_id,                      :integer

      t.column :company_id,                   :integer
      t.column :company,                      :string

      t.column :title,                        :string
      t.column :text,                         :text
      t.column :contacts,                     :text

      t.column :board_type,                   :string

      t.column :main,                         :boolean, :default => true, :nul => false
      t.column :active,                       :boolean, :default => true, :nul => false
      t.timestamps
    end
  end

  def self.down
    drop_table :boards
  end
end
