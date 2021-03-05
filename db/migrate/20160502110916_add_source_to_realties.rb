class AddSourceToRealties < ActiveRecord::Migration
  def change
    add_column :realties, :source, :string
    Realty.where('record_id IS NOT NULL').update_all(source: 'lekvi.cz')
  end
end
