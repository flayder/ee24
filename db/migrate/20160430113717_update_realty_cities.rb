class UpdateRealtyCities < ActiveRecord::Migration
  def up
    Realty.where(realty_city_id: 2).each do |realty|
      realty.update_attribute(:realty_city_id, 1)
    end
    Realty::Locality.where(realty_city_id: 2).each do |locality|
      locality.update_attribute(:realty_city_id, 1)
    end
    Realty::City.destroy(2)
  end

  def down
  end
end
