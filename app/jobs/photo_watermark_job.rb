class PhotoWatermarkJob < ResqueJob
  @queue = queue_name
  
  def self.perform photo_id
    photo = Photo.find photo_id
    photo.place_watermark! unless photo.watermarked?
  end
end