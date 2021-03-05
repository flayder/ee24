class SharedPhoto < ActiveRecord::Base
  mount_uploader :image, SharedPhotoUploader
  process_in_background :image

  belongs_to :doc, :polymorphic => true, :touch => true
end
