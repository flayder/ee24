# encoding : utf-8
module WithMainPhoto
  extend ActiveSupport::Concern

  included do
    has_many :photos, :as => :photo, :order => "main DESC", :dependent => :destroy
    has_one :shared_photo, :as => :doc, :dependent => :destroy
    scope :with_photo, includes(:photos).where('photos.photo_id IS NOT NULL')
    accepts_nested_attributes_for :photos, :allow_destroy => true
    attr_writer :main_photo

    after_commit :create_shared_photo, :on => :create
    after_commit :update_shared_photo, :on => :update

    def create_shared_photo
      base_image = self.main_photo.try(:image) || File.open(Rails.root.join('public/images/shared_background.png'))
      self.shared_photo = SharedPhoto.create(doc: self, image: base_image, main_photo_url: self.main_photo.try(:image).try(:url))
    end

    def update_shared_photo
      create_shared_photo unless shared_photo
      if previous_changes[:title] || self.main_photo.try(:image).try(:url) != self.shared_photo.main_photo_url
        base_image = self.main_photo.try(:image) || File.open(Rails.root.join('public/images/shared_background.png'))
        self.shared_photo.image = base_image
        self.shared_photo.update_attribute(:main_photo_url, self.main_photo.try(:image).try(:url))
      end
    end

    def main_photo
      unless @main_photo
        photo = nil
        unless self.photos.empty?
          main_photos = self.photos.main
          photo = main_photos.empty? ? self.photos.first : main_photos.first
        end
        self.main_photo = photo
      end
      @main_photo
    end

    def has_photos?
      self.photos and !self.photos.empty?
    end

    # TODO: remove this shit
    alias :old_photos_attributes= :photos_attributes=
    def photos_attributes=(attrs)
      # REFACTOR seems like this method could be omitted
      new_photos = attrs.select {|k, v| v[:id].nil? }

      unless new_photos.blank?
        new_photos[new_photos.keys.first][:image].each_with_index do |image, index|
          attrs[(new_photos.keys.first.to_i + index).to_s] = { :image => image }
        end
      end

      self.send(:old_photos_attributes=, attrs)
    end
  end
end
