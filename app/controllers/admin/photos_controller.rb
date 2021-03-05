# encoding : utf-8
class Admin::PhotosController < Admin::BaseController
  authorize_resource :photo

  include Modules::WithSearch

  def index
    search_hash = (params[:search].present? && params[:search][:meta_sort].present?) ? params[:search] : {"meta_sort" => "id.desc"}.merge(params[:search] || {})
    @search = Photo
    if params[:doc_content].present?
      @doc_content = params[:doc_content]
      doc_id = ThinkingSphinx.search(ThinkingSphinx.search(@doc_content), {classes: [Doc], with: {site_id: @site.id}}).map(&:id)
      event_id = ThinkingSphinx.search(ThinkingSphinx.search(@doc_content), {classes: [Event], with: {site_id: @site.id}}).map(&:id)
      gallery_id = ThinkingSphinx.search(ThinkingSphinx.search(@doc_content), {classes: [Gallery], with: {site_id: @site.id}}).map(&:id)
      @search = @search.where("(photo_type = 'Doc' AND photo_id IN (?)) OR (photo_type = 'Event' AND photo_id IN (?)) OR (photo_type = 'Gallery' AND photo_id IN (?))", doc_id, event_id, gallery_id)
    end
    @search = @search.metasearch(search_hash)
    @photos = @search.paginate(page: params[:page], per_page: 100)
  end

  def edit
    @photo = Photo.find(params[:id])
  end

  def bulk_update
    params[:ids].each do |id|
      next unless params[:photo][id].present?
      photo = Photo.find(id)
      photo.update_attributes(params[:photo][id].except(:comment, :watermark))
      set_photo_watermark(photo) if params[:photo][id][:watermark].present? && params[:photo][id][:watermark] == '1' && !photo.watermarked
      photo.set_photo_comment(params[:photo][id][:comment]) if params[:photo][id][:comment].present?
    end if params[:ids].present?
    redirect_to :back
  end

  def update
    @photo = Photo.find(params[:id])
    params[:photo].merge!({watermarked: false, commented: false}) if params[:photo][:image].present?
    @photo.update_attributes(params[:photo])
    if params[:photo][:image].present? && !params[:comment].present?
      comment = Magick::Image::read(params[:photo][:image].tempfile.path).first[:comment]
      @photo.set_photo_comment(comment) if comment.present?
    end

    set_photo_watermark(@photo) if params[:watermark].present? && params[:watermark] == '1' && !@photo.watermarked
    @photo.set_photo_comment(params[:comment]) if params[:comment].present?

    redirect_to :action => :index
  end

  def destroy
    @photo = Photo.find(params[:id])
    if @photo.destroy
      flash[:notice] = 'Фотография удалена'
    end
    redirect_to :action => :index
  end

  private

  def set_photo_watermark(photo)
    photo.image.watermark
    photo.save!
    photo.image.recreate_versions!
    photo.update_attribute(:watermarked, true)
  end

end
