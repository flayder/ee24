class AddRealtyKindToBoard < ActiveRecord::Migration
  def change
    add_column :boards, :realty_kind, :string
  end
end
