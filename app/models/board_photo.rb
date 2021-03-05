class BoardPhoto < ActiveRecord::Base
  belongs_to :photoable, :polymorphic => true
  mount_uploader :image, BoardPhotoUploader

  attr_accessible

  COMMON_FIELDS = [:position, :photoable_id, :photoable_type, :image, :image_cache, :remove_image]
  ADMIN_FIELDS = COMMON_FIELDS | [{ :as => :admin }]

  attr_accessible *COMMON_FIELDS
  attr_accessible *ADMIN_FIELDS
end
