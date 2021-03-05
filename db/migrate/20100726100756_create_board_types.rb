class CreateBoardTypes < ActiveRecord::Migration
  def self.up
    create_table :board_types do |t|
      t.string  :title
      t.integer :board_global_rubric_id
      t.timestamps
    end
    add_index :board_types, :board_global_rubric_id
    change_column :boards, :board_type, :integer
    rename_column :boards, :board_type, :board_type_id
    add_index :boards, :board_type_id
  end

  def self.down
    drop_table :board_types
    remove_index :boards, :board_type_id
    rename_column :boards, :board_type_id, :board_type
    change_column :boards, :board_type, :string
  end
end
