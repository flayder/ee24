# encoding : utf-8
module Modules
  module Blocks
    def self.included(base)
      super
      base.send :include, ClassMethods
    end

    module ClassMethods
      def block_linker
        @linker = @site.linkers.find_linker(request.url)
      end

      def block_micro_gallery(doc)
        return if !doc.main_photo || doc.main_photo == doc
        doc = @event if @event.present?

        @all_photos = doc.photos
        @photo = params[:photo_id] ? Photo.find(params[:photo_id]) : doc.main_photo
        @next_photo_id = @all_photos.size > @all_photos.index(@photo) + 1 ? @all_photos[doc.photos.index(@photo) + 1].id : @all_photos.first.id
        @prev_photo_id = @photo == @all_photos.first ? @all_photos.last.id : @all_photos[doc.photos.index(@photo) - 1].id
      end

      def change_photo
        @photo = Photo.find(params[:id])
        @doc = @photo.photo
        @all_photos = @doc.photos
        @next_photo_id = @all_photos.size > @all_photos.index(@photo) + 1 ? @all_photos[@doc.photos.index(@photo) + 1].id : @all_photos.first.id
        @prev_photo_id = @photo == @all_photos.first ? @all_photos.last.id : @all_photos[@doc.photos.index(@photo) - 1].id

        respond_to do |format|
          format.js{ render :template => "/templates/blocks/_micro_gallery.js.erb" }
          format.html{
            redirect_to @doc.url+"?photo_id=#{@photo.id}"
          }
        end
      end
    end
  end
end
