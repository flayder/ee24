# encoding : utf-8
class JobController < ApplicationController
  include Modules::WithCommonLayout

  before_filter :define_type, :except => [:index, :yvl]
  before_filter :find_career_docs, only: [:index, :index, :industry, :profession, :not_approved, :my]
  before_filter :login_required, :only => [:my, :new, :create]
  before_filter :owner_required, :only => [:edit, :update, :destroy]
  before_filter :find_industries, :except => [:destroy, :professions, :index, :yvl]
  before_filter :authorize, :only => [:approve, :not_approved]
  before_filter :set_section
  before_filter :get_ads
  before_filter :find_sub_rubrics

  def all_index
    respond_to do |format|
      @job_cache_key = job_cache_key 'job_all_index', true
      @job_items = index_job_items

      format.html do
        @broads = ["Работа"]
        render action: :index
      end

      format.rss do
        generate_rss(true)
      end
    end
  end

  def index
    respond_to do |format|
      format.html do
        find_job_items
        @regions = Region.all
        @industries = Industry.all
        @catalog = Catalog.joins(:vacancies).uniq.map {|c| [c, c.vacancies.for_main.count]}.sort_by {|c| c.last}.select {|c| c.last > 0}.reverse.first(5)
      end

      format.json do
        find_job_items
        render json: {col1: render_to_string('_list', layout: false, formats: [:html])}
      end

      format.rss do
        @job_items = Vacancy.approved.order("created_at DESC").includes(:user).limit(20)
        generate_rss
      end
    end
  end

  def not_actual
    list = Vacancy.approved.not_actual
    list = list.where('industry_id in (?)', params[:industry_ids]) if params[:industry_ids].present?
    list = list.where('region_id in (?)', params[:region_ids]) if params[:region_ids].present?
    @job_items = load_list list
    @regions = Region.all
    @industries = Industry.all
    @catalog = Catalog.joins(:vacancies).where('vacancies.approved = true').uniq.map {|c| [c, c.vacancies.count]}.sort_by {|c| c.last}.reverse.first(5)
    render :index
  end

  def filter
    @sel_industries =  params[:industry_ids].present? ? Industry.where(id: params[:industry_ids]) : []
    @sel_regions = params[:region_ids].present? ? Region.where(id: params[:region_ids]) : []
    render partial: 'job/filter_selected'
  end

  def find_job_items
    # @job_cache_key = job_cache_key 'job_index' unless (params[:industry_ids].present? || params[:region_ids].present?)
    list = Vacancy.approved.actual.not_closed
    if params[:industry_ids].present?
      list = list.where('industry_id in (?)', params[:industry_ids])
    end
    if params[:region_ids].present?
      list = list.where('region_id in (?)', params[:region_ids])
    end
    @job_items = load_list list
  end

  def show
    @job_item = @model.includes(:user, :industry, :professions, :photos).find_by_id params[:id]
    return render_404 unless @job_item

    authorize! :read, @job_item

    @relevant_job = Vacancy.for_main.joins(:professions).where('professions.id IN (?)', @job_item.profession_ids).where('vacancies.id != ?', @job_item.id).uniq.limit(5)

    @industry = @job_item.industry

    set_show_meta_fields @job_item
    @job_item.inc_page_views! @site
  end

  def new
    @job_item = @model.new(:busy => 'full', :user_id => current_user.id)
    build_photos
    set_region
    new_name = t("new_#{params[:type]}")
    @broads = [[@plural_name, url_for(:action => :index, :type => params[:type])], new_name]
    @meta_title = [new_name, @site.short_title]
  end

  def create
    @job_item = Vacancy.new(params[:vacancy])
    @job_item.user = current_user
    if @job_item.save
      flash[:notice] = create_notice(@job_item)
      redirect_to action: :index
    else
      set_region
      render action: :new
    end
  end

  def edit
    build_photos
    set_region
    edit_name = t("edit_#{params[:type]}")
    @broads = [[@plural_name, url_for(:action => :index, :type => params[:type])], edit_name]
    @meta_title = [edit_name, @site.short_title]
  end

  def update
    init_profession_ids_params

    assign_attributes @job_item
    @job_item.reset_approved unless can?(:manage, @job_item)

    if @job_item.save
      flash[:notice] = update_notice
      redirect_to action: :index, type: params[:type]
    else
      build_photos
      set_region
      assign_create_update_meta_fields t("edit_#{params[:type]}")
      render action: :edit
    end
  end

  def destroy
    authorize! :destroy, @job_item

    if @job_item.destroy
      flash[:notice] = t("#{params[:type]}_destroyed")
    end
    redirect_to :action => :index, :type => params[:type]
  end

  def industry
    @industry = Industry.find_by_id params[:industry_id]
    return render_404 unless @industry

    @job_cache_key = job_cache_key "job_industry#{@industry.id}"
    @job_items = load_items @model, :industry, params[:industry_id]

    @broads = [[@plural_name, url_for(action: :index, type: params[:type])], @industry.title]
    set_industry_meta_fields @industry

    render :action => :index
  end

  def profession
    @profession = Profession.includes(:industry).find_by_id params[:profession_id]
    return render_404 unless @profession

    @industry = @profession.industry

    @job_cache_key = job_cache_key "job_profession#{@profession.id}"
    @job_items = load_items @model, :for_profession, params[:profession_id]

    set_professtion_meta_fields
    render action: :index
  end

  def professions
    @professions = Profession.where(industry_id: params[:industry_id])
    render partial: 'job/professions', layout: false
  end

  # фид вакансий для яндекса
  def yvl
    @vacancies = Vacancy.approved.order('created_at desc').includes(:industry, :professions).select {|v| v.valid?}
    respond_to do |format|
      format.xml
    end
  end

  def not_approved
    @job_items = load_list @model.not_approved
    @meta_title = 'Неподтверждённые '
    @broads = ['Неподтверждённые статьи']
    render :action => :index
  end

  def my
    @job_items = load_list @model.where(user_id: current_user.id)
    @broads = ["Мои #{t(params[:type].pluralize)}"]
    @meta_title = "Мои #{t(params[:type].pluralize)}"
    render action: :index
  end

  def approve
    @job_item = @model.find(params[:id])
    return render_404 unless @job_item

    @job_item.approve!
    redirect_to :action => :not_approved
  end

  def region_cities
    @cities = RegionCity.where(region_id: params[:region_id])
    respond_to do |format|
      format.json {
        render json: {
            cities: render_to_string('_json_cities_list', locals: {cities: @cities}, layout: false, formats: [:html])
        }
      }
    end
  end

  private
  # TODO
  # why Doc???
  def authorize
    authorize! :manage, Doc
  end

  def find_career_docs
    @career_docs = @site.doc_rubrics.find_by_link('career').docs.approved.order('created_at desc').limit(3)
  end

  def build_photos
    not_enough = 6 - @job_item.photos.size
    not_enough.times do
      @job_item.photos.build
    end
  end

  def set_region
    if @job_item.is_a?(Vacancy)
      @regions = Region.all
      @vac_region = @job_item.region
      @vac_region ||= @regions.first
      @cities = @vac_region.cities
      #@job_item.region_city ||= @regions.first.cities.first
    end
  end

  def owner_required
    @job_item = @model.includes([:industry, :professions, :user, :photos]).find params[:id]
    @professions = @job_item.industry.professions if @job_item.industry

    authorize! :edit, @job_item
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def define_type
    unless ['vacancy', 'resume'].include?(params[:type])
      render_404
      return false
    end
    @model = params[:type].classify.constantize
  end

  def find_industries
    @industries = Industry.all
    @block_industries = Industry.order('job_items_count DESC').limit(20)
    @plural_name = t(params[:type].pluralize)
  end

  def layout_params
    {
      rss_links_folder: 'job'
    }
  end

  def generate_rss add_model_name = false
    @add_model_name = add_model_name

    headers['Content-Type'] = 'application/xml; charset=utf-8'
    render layout: false, template: 'job/index'
  end

  def job_cache_key prefix, index = false
    job_cache_key = "#{prefix}_#{@site.id}_#{params[:page]}"
    job_cache_key << '_admin' if @admin_access
    job_cache_key << (index ? "/#{Vacancy.last_updated_cache_key}#{Resume.last_updated_cache_key}" : "/#{@model.last_updated_cache_key}")
  end

  def load_list base_scope
    base_scope.order('created_at DESC').includes(:user).paginate(page: params[:page], per_page: 10)
  end

  def update_notice
    notice = 'Обновление прошло успешно.'
    notice << ' ' + @job_item.class.model_name.human + ' появится на сайте после подтверждения администратором' unless @job_item.approved?
    notice
  end

  def index_sql_query type
    "SELECT #{JobItem::INDEX_ATTRIBUTES.join(', ')}, '#{type}' job_type FROM #{type.pluralize} WHERE approved = 1"
  end

  def index_job_items
    Vacancy.paginate_by_sql("#{index_sql_query('resume')} UNION #{index_sql_query('vacancy')} ORDER BY created_at DESC", page: params[:page], per_page: 20)
  end

  def set_professtion_meta_fields
    @broads = [[@plural_name, url_for(:action => :index, :type => params[:type])], [@industry.title, url_for(:action => 'industry', :type => params[:type], :industry_id => @industry.id)], @profession.title]
    @meta_title = [@profession.title, @industry.title, @plural_name, @site.short_title].join(' / ')
  end

  def set_industry_meta_fields industry
    @meta_description = industry.meta_description(@site)
    @meta_keywords = industry.meta_keywords(@site)
    @meta_title = industry.meta_title(@site, ' / Работа ' + @site.short_title)

    @seo ||= industry.seo(@site)
    @seo_about ||= industry.seo_about(@site)
    @seo_sub_text ||= industry.seo_sub_text(@site)
  end

  def load_items model, scope, id
    model.approved.includes(:user).send(scope, id).order('created_at desc').paginate(page: params[:page], per_page: 20)
  end

  def create_notice job_item
    job_item.approved ? 'Всё прошло успешно.' : job_item.class.model_name.human + ' появится на сайте после подтверждения администратором'
  end

  def assign_create_update_meta_fields name
    @broads = [[@plural_name, url_for(:action => :index, :type => params[:type])], name]
    @meta_title = [name, @site.short_title]
  end

  def init_profession_ids_params
    params[params[:type]][:profession_ids] ||= []
  end

  def set_index_meta_fields
    @meta_title = [@plural_name, @site.short_title]
    @broads = [["Работа", job_url], @plural_name]
  end

  def set_show_meta_fields job_item
    @broads = [["Работа", job_url], [@plural_name, url_for(:action => :index, :type => params[:type])], [@job_item.industry.title, url_for(:action => 'industry', :type => params[:type], :industry_id => @job_item.industry.id)], job_item.title]
    @meta_title = [job_item.title, job_item.industry.title, @plural_name, @site.short_title]
  end

  def assign_attributes job_item
    job_item.assign_attributes params[params[:type]], :as => can?(:manage, job_item) ? :admin : :default
  end

  def find_sub_rubrics
    @sub_rubrics = @site.doc_global_rubrics.find_by_link('job').doc_rubrics
  end
end
