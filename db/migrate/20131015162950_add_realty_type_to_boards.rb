class AddRealtyTypeToBoards < ActiveRecord::Migration
  def change
    add_column :boards, :realty_type, :string
  end
end
