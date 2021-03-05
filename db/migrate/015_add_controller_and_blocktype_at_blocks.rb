class AddControllerAndBlocktypeAtBlocks < ActiveRecord::Migration
  def self.up
    add_column( "blocks", "block_type" , :string, { :null => false, :default => "delault" })
    add_column( "blocks", "link" , :string, { :null => true })
  end

  def self.down
    remove_column("blocks", "block_type")
    remove_column("blocks", "link")
  end
end
