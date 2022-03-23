# encoding : utf-8
class CatalogController < ApplicationController
  include Modules::WithLastModified
  include Modules::WithCommonLayout
  include Modules::WithMyAction
  include Modules::WithNotApprovedAction
  include Modules::WithMultipleAds
  include Modules::WithSidebarPhotoSlider

  before_filter :set_section
  before_filter :get_rubric, :get_rubric_ads, :only => [:list, :show, :comments]
  before_filter :get_ads
  before_filter :login_required, :only => [:new, :create, :edit, :update, :destroy, :not_approved, :my]
  before_filter :blocks_for_catalog
  before_filter :block_linker

  def index
    respond_to do |format|
      format.html do
        @catalog_rubrics = @site.catalog_rubrics.roots.order('position, title')
        set_index_last_modified
        set_index_meta_fields
        @breadcrumbs = [
          {
            title: "Компания",
            url: "/catalog"
          }
        ]
        render :index
      end
      format.rss do
        @catalogs = @site.catalogs.approved.by_language.order('created_at DESC').limit(20)

        headers['Content-Type'] = 'application/xml; charset=utf-8'
        render layout: false, template: 'catalog/index'
      end
    end
  end

  def list
    @catalog_cache_key = "catalog_list_rubric#{@rubric.id}_#{@site.id}_#{params[:page]}/#{Catalog.last_updated_cache_key}"
    @rubrics = @rubric.children.present? ? @rubric.children : @rubric.self_and_siblings
    @places = if @rubric.catalogs.present?
      @rubric.catalogs.site(@site.id).approved.by_language.order('(position is null), position').paginate(page: params[:page], per_page: 10)
    else
      @rubrics.flat_map{|rubric| rubric.catalogs.approved.by_language}.uniq.sort_by{|e| [e.recommend ? 0 : 1, e.position ? 0 : 1, e.position || 0, e.title]}.paginate(page: params[:page], per_page: 10)
    end

    set_list_broads @rubric
    set_list_meta_fields @rubric
    set_list_last_modified @rubric
    respond_to do |format|
      format.html
      format.json { render json: {col1: render_to_string('catalog/_items', layout: false, formats: [:html])} }
    end
  end

  def new
    parent = @site.catalog_rubrics.find params[:parent_id] if params[:parent_id]
    @catalog = @site.catalogs.build parent_id: parent.try(:id)

    @broads = [['Компании', '/catalog'], 'Добавить организацию']
    @meta_title = ["Добавление компании", "#{@site.portal_title} #{@site.domain}"]
  end

  def create
    @catalog = @site.catalogs.build
    @catalog.rubric_ids = params[:catalog][:rubric_ids]
    @catalog.user_id = current_user.id
    @catalog.hcard_converted = true
    @catalog.assign_attributes params[:catalog], :as => can?(:manage, @catalog) ? :admin : :default
    @catalog.photos.each { |p| p.site_id = @site.id }
    @place = @catalog

    unless has_title?
      @catalog.errors.add(:base, :title_not_present_error)
      render :new
      return
    end

    if @catalog.save
      @broads = [['Компании', '/catalog'], 'Организация добавлена']
      flash[:notice] = "Компания успешно добавлена"
      render :action => "show"
      return false
    else
      @broads = [['Компании', '/catalog'], 'Добавить организацию']
      render :action => "new"
      return false
    end
  end

  def approve
    @catalog = Catalog.find_by_id(params[:id])
    return render_404 unless @catalog

    authorize! :approve, @catalog

    @catalog.approve!
    redirect_to :action => :not_approved
  end

  def show
    @place = Catalog.site(@site.id).includes(:galleries).find_by_id params[:id]
    return render_404 unless @place

    authorize! :read, @place

    set_show_broads @place, @rubric
    set_show_meta_fields @place, @rubric
    set_last_modified @place unless logged_in?

    @place.inc_page_views! @site

    #render json: @place
  end

  def comments
    @place = Catalog.site(@site.id).where(is_commentable: true).includes(:galleries).find_by_id(params[:id])
    return render_404 unless @place
    authorize! :read, @place

    set_show_broads @place, @rubric
    set_show_meta_fields @place, @rubric
    set_last_modified @place unless logged_in?
  end

  def edit
    @catalog = Catalog.site(@site.id).find_by_id(params[:id])
    return render_404 unless @catalog
    authorize! :edit, @catalog
    @broads = [['Компании', '/catalog'], 'Редактировать организацию']
    @meta_title = ["Редактирование компании / #{@site.portal_title} #{@site.domain}"]
  end

  def update
    @catalog = Catalog.site(@site.id).find_by_id(params[:id])
    return render_404 unless @catalog
    authorize! :update, @catalog

    unless has_title?
      @catalog.errors.add(:base, :title_not_present_error)
      render :edit
      return
    end

    # REFACTOR
    has_access = can? :update, @catalog

    unless has_access
      @catalog.approved = false
      @catalog.approved_at = nil
    end

    @catalog.site_id = @site.id
    @place = @catalog
    @catalog.set_address(params[:catalog][:street_address])
    params[:catalog][:user_id] = User.where("id = ? or email = ?", params[:catalog][:user_id], params[:catalog][:user_id]).first.try(:id) || current_user.id
    @broads = [['Компании', '/catalog'], 'Редактировать организацию']
    if @catalog.update_attributes(params[:catalog], :as => has_access ? :admin : :default)
      flash[:notice] = "Компания успешно обновлена"
      redirect_to @catalog.approved? ? @catalog.url : user_companies_path(current_user.subdomain)
    else
      render :edit
    end
  end

  def destroy
    @catalog = Catalog.site(@site.id).find_by_id(params[:id])
    return render_404 unless @catalog
    authorize! :manage, @catalog
    flash[:notice] = 'Компания удалена' if @catalog.destroy
    redirect_to catalogs_url
  end

  def not_approved
    set_not_approved Catalog, :@places, @site, params
    @meta_title = 'Неподтверждённые компании'
    @broads = ['Неподтверждённые компании']
    render :list
  end

  def my
    instantiate_my :@places, :catalogs, 'компании', :not_approved
  end

  private

  def has_title?
    has_title = false
    params[:catalog][:catalog_descriptions_attributes].each do |k, v|
      has_title ||= v[:title].present?
    end
    has_title
  end

  def get_rubric_ads
    @ad_codes ||= {}
    rubric_ids = @rubric.self_and_ancestors.pluck(:id)
    find_more_banners(@ad_codes, 'CatalogRubric', rubric_ids) if need_more_ads?
  end

  def blocks_for_catalog
    @global_rubrics = CatalogRubric.site(@site).where(parent_id: nil).order('position, title')
  end

  def layout_params
    {
      :rss_links_folder => 'catalog'
    }
  end

  def get_rubric
    @rubric = CatalogRubric.site(@site).find_by_old_id extract_old_id

    if @rubric
      case params[:action]
      # when 'show', 'edit', 'comments'
      #   redirect_to "/catalog/#{@rubric.id}/#{params[:action]}/#{params[:id]}", status: :moved_permanently
      #   return
      when 'list'
        redirect_to "/catalog/list/#{@rubric.id}", status: :moved_permanently
        return
      end
    else
      @rubric = CatalogRubric.site(@site).find extract_old_id
    end
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def index_cache_key
    "views/catalog_index_#{@site.id}/#{Catalog.last_updated_cache_key}"
  end

  def set_index_meta_fields
    @meta_title ||= ["Компании #{@site.short_title}. #{@site.portal_title}"]
    @broads = ['Компании']
  end

  def set_index_last_modified
    response.headers['Last-Modified'] = Catalog.last_updated_at.httpdate if (!logged_in? && Catalog.last_updated_at.present?)
  end

  def extract_old_id
    %w(show comments).include?(params[:action]) ? params[:rubric_id] : params[:id]
  end

  def set_list_last_modified rubric
    last_place = rubric.catalogs.site(@site).approved.by_language.order("catalogs.created_at").first
    response.headers['Last-Modified'] = last_place.updated_at.httpdate if (!logged_in? && last_place && last_place.updated_at)
  end

  def list_meta_title rubric
    if rubric.meta_title(@site).blank?
      ["Компании"] + rubric.ancestors.map{ |catalog| catalog.meta_title(@site) }
    else
      [rubric.meta_title(@site)]
    end
  end

  def set_list_meta_fields rubric
    @seo ||= rubric.seo(@site)
    @seo_about ||= rubric.seo_about(@site)
    @seo_sub_text ||= rubric.seo_sub_text(@site)

    @meta_description = rubric.meta_description(@site)
    @meta_keywords = rubric.meta_keywords(@site)
    @meta_title ||= list_meta_title rubric
  end

  def set_list_broads rubric
    @broads = [["Компании", "/catalog"]]
    @broads += rubric.ancestors.map{ |catalog| [catalog.title, "/catalog/list/#{catalog.id}"] }
    @broads << rubric.title
  end

  def set_show_broads place, rubric
    @broads = [["Компании", "/catalog"]]
    @broads += rubric.ancestors.map{ |catalog| [catalog.title, "/catalog/list/#{catalog.id}"] }
    @broads << [rubric.title, "/catalog/list/#{rubric.id}"]
    @broads << place.title
  end

  def set_show_meta_fields place, rubric
    if @seo = Seo.site(@site.id).where(path: request.path).where('seo_type IS NULL OR seo_type = ""').first
      @seo_about = @seo.about
      @seo_sub_text = @seo.sub_text
      #@seo_text = @seo.text

      @meta_title ||= @seo.title
      @meta_description ||= @seo.description
      @meta_keywords ||= @seo.keywords
    else
      @meta_title ||= "#{@place.title} | #{t('catalog.meta_title')}"
      @meta_description ||= t('catalog.meta_description', title: @place.title)
    end
  end
end
