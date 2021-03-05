# encoding : utf-8
class PhotoController < ApplicationController
  include Modules::WithMyAction
  include Modules::WithCommonLayout
  include Modules::WithDateSearch
  include Modules::WithMultipleAds
  include Modules::WithNotApprovedAction

  cache_sweeper :photo_sweeper

  before_filter :set_section
  before_filter :blocks

  before_filter :redirect_old_urls, :only => [:index, :rubric, :list, :show]
  before_filter :find_rubric, :only => [:rubric, :list, :show]
  before_filter :login_required, :only => [:my, :new, :create, :edit, :update, :destroy]
  before_filter :authorize, :only => [:approve, :not_approved]
  before_filter :get_rubric_ads, :only => [:rubric, :list, :show]
  before_filter :get_ads
  before_filter :find_sub_rubrics

  def index
    @photo_cache_key = index_cache_key
    get_broads_for_view
    @galleries = @site.galleries.approved.order('created_at DESC').paginate(page: params[:page], per_page: 20)
    respond_to do |format|
      format.html {}
      format.json {
        render json: {
            col1: render_to_string('_galleries_list', locals: {galleries_list: @galleries}, layout: false, formats: [:html]),
            page: @galleries.next_page
        }
      }
      format.rss do
        generate_rss(rss_index_galleries, 'Фотогалереи', 'photo')
      end
    end
  end

  def rubric
    @photo_cache_key = index_cache_key
    get_broads_for_view
    @galleries = @rubric.galleries.approved.order('created_at DESC').paginate(page: params[:page], per_page: 20)
    @meta_title ||= generate_title(@rubric)
    set_index_last_modified
  end

  def my
    instantiate_my :@galleries, :galleries, 'фоторепортажи', :rubric
  end

  def list
    @gallery = @rubric.galleries.find_by_id(params[:gallery_id])
    return render_404 unless @gallery
    @photos = @gallery.photos.order("created_at")

    @meta_title ||= generate_title(@gallery, @rubric)
    @meta_description = @gallery.annotation

    get_broads_for_view
    @gallery.inc_page_views! @site
  end

  def show
    @gallery = @rubric.galleries.find_by_id(params[:gallery_id])
    return render_404 unless @gallery
    url = @gallery.url
    url += "##{params[:photo_id]}" if params[:photo_id].present?
    redirect_to  url
    return false
  end

  def new
    @gallery = @site.galleries.build
    @gallery.photos.build

    @broads = [["Фото", "/photo"], 'Добавление фоторепортажа']
    @meta_title = ['Добавление фоторепортажа', "Фото"]
  end

  def create
    @gallery = @site.galleries.build

    assign_create_attributes

    if @gallery.save
      flash[:notice] = create_notice
      redirect_to action: :index
    else
      @gallery.photos.build
      render action: :new
    end
  end

  def edit
    @gallery = Gallery.site(@site.id).find_by_id(params[:id])
    return render_404 unless @gallery
    authorize! :edit, @gallery
    @gallery.photos.build
    assign_edit_meta_attributes
  end

  def update
    @gallery = @site.galleries.find_by_id params[:id]
    return render_404 unless @gallery
    authorize! :update, @gallery

    params[:gallery][:user_id] = User.where("id = ? or email = ?", params[:gallery][:user_id], params[:gallery][:user_id]).first.try(:id) || current_user.id

    if @gallery.update_attributes(params[:gallery], as: (can?(:manage, @gallery) ? :admin : :default))
      flash[:notice] = 'Фоторепортаж успешно обновлен'
      redirect_to @gallery.url
    else
      assign_edit_meta_attributes
      render action: :edit
    end
  end

  def approve
    @gallery = Gallery.site(@site.id).find_by_id(params[:id])
    return render_404 unless @gallery
    @gallery.approve!
    redirect_to :action => :not_approved
  end

  def not_approved
    set_not_approved Gallery, :@galleries, @site, params

    @meta_title = 'Неподтверждённые фоторепортажи'
    @broads = ['Неподтверждённые фоторепортажи']
    render :index
  end

  def destroy
    gallery = @site.galleries.find_by_id(params[:id])
    return render_404 unless gallery
    authorize! :destroy, gallery
    flash[:notice] = 'Фоторепортаж удалён' if gallery.destroy
    url = (request.referer.present? && !request.referer.include?(gallery.url)) ? :back : '/photo'
    redirect_to url
  end

  private

  def blocks
    @photo_rubrics = PhotoRubric.site(@site).order('title')
  end

  def get_rubric_ads
    @ad_codes ||= {}
    if need_more_ads? && @rubric.present?
      set_rubric_ads(@rubric)
    end
  end

  def authorize
    authorize! :manage, Gallery
  end

  def generate_title *rubrics
    rubrics = rubrics.compact.map! { |rubric| rubric.title }
    rubrics << @meta_title if @meta_title.present?
    rubrics.join(" / ")
  end

  def redirect_old_urls
    if params[:old_list_id]
      gallery = Gallery.approved.find(params[:old_list_id])
      redirect_to gallery.list_url, status: :moved_permanently
      return false
    end
  end

  def get_broads_for_view
    @broads = @rubric.present? ? [['Фото', '/photo/']] : ['Фото']
    @broads << @rubric.title if (@rubric.present? && !@gallery.present?)
    @broads << @gallery.title if @gallery.present?
  end

  def find_rubric
    redirect_url_with_spaces
    @rubric = @site.photo_rubrics.find_by_link(params[:global_rubric_link]) if params[:global_rubric_link].present?
  end

  def find_sub_rubrics
    @sub_rubrics = @site.photo_rubrics
  end

  def layout_params
    { :rss_links_folder => 'photo' }
  end

  def create_notice
    notice = 'Фоторепортаж успешно создан'
    notice << '. Он появится на сайте после модерации.' unless can?(:manage, @gallery)
  end

  def assign_create_attributes
    @gallery.photo_rubric_id = params[:gallery][:photo_rubric_id]
    @gallery.from_user = !can?(:manage, @gallery)
    @gallery.assign_attributes params[:gallery], :as => can?(:manage, @gallery) ? :admin : :default
    @gallery.user = User.where("id = ? or email = ?", params[:gallery][:user_id], params[:gallery][:user_id]).first || current_user
  end

  def assign_edit_meta_attributes
    @broads = [['Фото', '/photo'], 'Редактировать фоторепортаж']
    @meta_title = ["Редактирование фоторепортажа / #{@site.portal_title} #{@site.domain}"]
  end

  def redirect_url_with_spaces
    if params[:global_rubric_link].present? && params[:global_rubric_link].include?(' ')
      redirect_to compact_url_spaces(request, params[:global_rubric_link])
      return false
    end
  end

  def compact_url_spaces request, key
    CGI::unescape(request.url).gsub(key, key.gsub(' ', ''))
  end

  def index_cache_key
    key = "#{@site.id}/photo_"
    key << Russian::translit(@rubric.link) if @rubric.present?
    key << "#{params[:page]}/#{Gallery.last_updated_cache_key}"
    key
  end

  def rss_index_galleries
    @site.galleries.approved.without_my_voronezh.order('created_at DESC').paginate(page: params[:page], per_page: 20)
  end

  def set_index_last_modified
    last_gallery = @site.galleries.approved.last
    response.headers['Last-Modified'] = last_gallery.updated_at.httpdate if !logged_in? && last_gallery.present?
  end
end
