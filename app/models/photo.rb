# encoding : utf-8
class Photo < ActiveRecord::Base
  mount_uploader :image, PhotoUploader
  process_in_background :image

  COMMON_FIELDS = [:photo_type, :image, :title, :main, :on_main, :commented,
                  :watermarked, :image_processing, :image_cache, :remove_image, :_destroy]
  ADMIN_FIELDS = COMMON_FIELDS | [{ as: :admin}]

  attr_accessible *COMMON_FIELDS
  attr_accessible *ADMIN_FIELDS

  belongs_to :photo, :polymorphic => true, :touch => true

  scope :main, where(:main => true)
  scope :other, where(:main => false)
  scope :on_main, order("on_main DESC").limit(4)
  scope :for_gallery, where(photo_type: 'Gallery')

  after_commit :place_watermark_async, :on => :create

  def need_watermark?
    no_watermark = self.photo.respond_to?(:no_watermark?) ? self.photo.no_watermark? : false
    self.photo_type.in?(["Gallery"]) && !no_watermark
  end

  def place_watermark_async
    Resque.enqueue PhotoWatermarkJob, id
  end

  def place_watermark!
    if need_watermark?
      self.image.recreate_versions!
      update_attribute(:watermarked, true)
      update_comment
    end
  end

  def url
    (Rails.env == 'production' ? 'https://' + Settings.portal_domain : '') + show_url
  end

  #страница просмотра фото
  def show_url
    #галерея
    if self.photo.respond_to?(:list_url)
      self.photo.list_url.gsub('list', 'show')+"/#{self.id}"
    #не галерея
    elsif self.photo.respond_to?(:url)
      self.photo.url
    else
      '#'
    end
  end

  def set_photo_comment(comment)
    return unless self.image.file.exists?
    self.image.versions.keys.each do |version|
      file_path = self.image.send(version).try(:file).try(:file)
      next unless File.exist?(file_path)
      file = Magick::Image::read(file_path).first
      if file['comment'] != comment
        file['comment'] = comment
        file.write(file_path)
      end
    end
    file = Magick::Image::read(self.image.file.file).first
    if file['comment'] != comment
      file['comment'] = comment
      file.write(self.image.file.file)
    end
    self.update_attribute(:commented, true)
  end

  def update_comment
    return unless self.image.present? && self.image.file.exists?
    file = Magick::Image::read(self.image.file.file).first
    comment = file['comment']
    set_photo_comment(comment) if comment.present?
  end

  def read_comment
    return nil unless self.image.present? && self.image.file.exists?
    file = Magick::Image::read(self.image.file.file).first
    file['comment']
  end
end
