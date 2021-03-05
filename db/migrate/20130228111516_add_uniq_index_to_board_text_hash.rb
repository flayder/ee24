class AddUniqIndexToBoardTextHash < ActiveRecord::Migration
  def change
    add_index :boards, [:text_hash, :site_id], unique: true
  end
end
