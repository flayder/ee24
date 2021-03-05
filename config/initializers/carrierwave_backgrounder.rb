CarrierWave::Backgrounder.configure do |c|
  c.backend :resque, queue: :gallery_photo_job
end
