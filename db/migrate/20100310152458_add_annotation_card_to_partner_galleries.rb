class AddAnnotationCardToPartnerGalleries < ActiveRecord::Migration
  def self.up
    add_column :partner_galleries, :annotation_card, :text
  end

  def self.down
    remove_column :partner_galleries, :annotation_card
  end
end
