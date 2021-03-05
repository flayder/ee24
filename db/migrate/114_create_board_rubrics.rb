class CreateBoardRubrics < ActiveRecord::Migration
  def self.up
    create_table :board_rubrics do |t|
      t.column :title,                        :string
      t.column :main,                         :boolean, :default => true, :nul => false
      t.column :count_pokupka,                :integer, :default => 0, :nul => false
      t.column :count_prodasha,               :integer, :default => 0, :nul => false
      t.timestamps
    end
  end

  def self.down
    drop_table :board_rubrics
  end
end
