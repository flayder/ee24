# encoding : utf-8
class AfishaController < ApplicationController
  include Modules::WithCommonLayout
  include Modules::WithMyAction
  include Modules::WithDateSearch
  include Modules::WithNotApprovedAction
  include Modules::WithApproveAction
  include Modules::WithSidebarPhotoSlider

  cache_sweeper :event_sweeper

  before_filter :find_event, only: [:show_doc, :show_event, :comments, :edit, :update, :destroy]
  before_filter :set_section, :find_event_rubrics
  before_filter :get_rubric, :get_rubric_ads, :only => [:rubric, :show_event, :comments]
  before_filter :get_ads
  before_filter :login_required, :only => [:my, :new, :create, :edit, :update, :destroy]
  before_filter :get_latest_events, only: [:index, :show_event, :rubric]

  def index
    set_index_meta_fields
    @date = find_date(params)
    @breadcrumbs = [
      {
        title: "Ближайшие события",
        url: "/afisha"
      }
    ]
    @events = if @date
      @site.events.approved.current(@date).by_language.order(:finish_date).paginate(page: 1, per_page: 100)
    else
      @site.events.approved.current_or_future(Date.current).by_language.order(:finish_date).paginate(page: params[:page], per_page: 14)
    end

    respond_to do |format|
      format.html
      format.json { render_next_page }
      format.rss do
        generate_rss(@events, 'Афиша', 'afisha', 'Афиша')
      end
    end
  end

  def my
    instantiate_my :@events,  :events, 'события', :not_approved
  end

  def rubric
    @date = find_date(params)
    @events = if @date
      @site.events.approved.where(event_rubric_id: [@rubric.id]).current(@date).by_language.order(:finish_date).paginate(page: 1, per_page: 100)
    else
      @site.events.approved.where(event_rubric_id: [@rubric.id]).current_or_future(Date.current).by_language.order(:finish_date).paginate(page: params[:page], per_page: 14)
    end
    respond_to do |format|
      format.html {
        set_rubric_meta_fields
        render :index
      }
      format.json { render_next_page }
      format.rss do
        events = @rubric.events.site(@site.id).approved.order("created_at DESC").limit(20)
        generate_rss(events, 'Афиша', 'afisha', @rubric.title)
      end
    end
  end

  def show_doc
  end

  def show_event
    @events = @site.events.approved.current_or_future(Date.current).order(:finish_date).limit(10)

    authorize_with_preview

    set_show_meta_fields @event

    @event.inc_page_views! @site
  end

  def comments
  end

  def date
    @start_date = extract_date_range(params).first

    @events = event_rubrics(params[:id]).inject({}) do |events, rubric|
      events[rubric] = @site.events.approved.order("created_at DESC").where(event_rubric_id: rubric.id).where("DATE(?) BETWEEN DATE(start_date) AND DATE(finish_date)", @start_date)
      events
    end

    set_date_meta_fields
    render action: :index
  end

  def new
    @event = @site.events.build
    @event.photos.build(:main => true)
    @rubrics = EventRubric.site(@site).where(user_added: true)

    @broads = [["Афиша", "/afisha"], 'Добавление события']
    @meta_title = ['Добавление события', "Афиша"]
  end

  def create
    @event = @site.events.build
    @event.event_rubric_id = params[:event][:event_rubric_id]
    @event.language = I18n.locale.to_s

    @event.assign_attributes params[:event], :as => can?(:manage, @event) ? :admin : :default
    @event.user = User.where("id = ? or email = ?", params[:event][:user_id], params[:event][:user_id]).first || current_user

    @broads = [["Афиша", "/afisha"], 'Добавление события']
    @meta_title = ['Добавление события', "Афиша"]

    if @event.save
      flash[:notice] = 'Событие успешно создана.'
      redirect_to :action => :index
    else
      @event.photos = [@event.photos.build]
      @rubrics = EventRubric.site(@site).where(:user_added => true)
      render :action => :new
    end
  end

  def edit
    authorize! :manage, @event
    @event.photos.build
    @rubrics = EventRubric.site(@site).where(:user_added => true)
    @broads = 'Редактирование статьи'
    @meta_title = 'Редактирование статьи'
  end

  def update
    authorize! :update, @event

    params[:event][:user_id] = User.where("id = ? or email = ?", params[:event][:user_id], params[:event][:user_id]).first.try(:id) || @event.user.id

    if @event.update_attributes(params[:event], as: (can?(:update, @event) ? :admin : :default))
      flash[:notice] = 'Статья успешно обновлена'
      if @event.approved?
        redirect_to @event.url
      else
        redirect_to :action => :index
      end
    else
      @rubrics = @section.rubrics
      @broads = 'Редактирование статьи'
      @meta_title = 'Редактирование статьи'
      render :action => :edit
    end
  end

  def not_approved
    set_not_approved Event, :@events, @site, params
    @meta_title = 'Неподтверждённые события'
    @broads = ['Неподтверждённые события']
    render :index
  end

  def approve
    approve! Event, params[:id], @site
  end

  def destroy
    authorize! :destroy, @event
    @event.destroy

    redirect_to action: :index
  end

  private

  def find_event
    @event = Event.site(@site.id).find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def get_latest_events
    @latest_events = Event.site(@site.id).approved.current_or_future(Date.current).order("created_at desc").limit(5)
  end

  def get_rubric
    link = params[:rubric] || params[:id]
    @rubric = EventRubric.site(@site).link(link).first!
  end

  def get_rubric_ads
    set_rubric_ads(@rubric) if @rubric.present?
  end

  def find_event_rubrics
    @event_rubrics = @site.event_rubrics
    @sub_rubrics = @event_rubrics
  end

  def layout_params
    {
      :rss_links_folder => 'afisha'
    }
  end

  def event_rubrics id
    if id
      @rubric = @section.rubrics(id).first
      [@rubric]
    else
      @event_rubrics
    end
  end

  def set_date_meta_fields
    @broads = [["Афиша", "/afisha"], "Календарь"]
    @meta_title = ["Афиша #{@site.short_title}", "Календарь"]
  end

  def set_show_meta_fields event
    @broads = [["Афиша", "/afisha"], [event.rubric.title, "/afisha/#{event.rubric.link}"], event.title]
    @meta_description ||= event.rubric.meta_description(@site)
    @meta_keywords ||= event.rubric.meta_keywords(@site)
    @meta_title ||= [event.title, event.rubric.title, "Афиша", @site.short_title + ' ' + @site.domain + '. ' + @site.portal_title].reverse
  end

  def set_index_meta_fields
    @meta_title ||= ["Афиша #{@site.short_title}"]
    @meta_description ||= "#{@site.short_title} афиша города"
    @broads = ["Афиша"]
  end

  def set_rubric_meta_fields
    unless params[:past]
      @seo ||= @rubric.seo(@site)
      @seo_about ||= @rubric.seo_about(@site)
      @seo_sub_text ||= @rubric.seo_sub_text(@site)

      #отображение через seo_text @seo
      #@seo_text ||= @rubric.seo_text(@site)

      #@about ||= @rubric.seo_about(@site)
    end

    @broads = [["Афиша", "/afisha"], @rubric.title]
    @meta_title ||= [@rubric.meta_title(@site)]
    @meta_description ||= @rubric.meta_description(@site)
    @meta_keywords ||= @rubric.meta_keywords(@site)
  end

  def find_date(params)
    if params[:year] && params[:month] && params[:day]
      begin
        "#{params[:year]}/#{params[:month]}/#{params[:day]}".to_date
      rescue
        false
      end
    else
      false
    end
  end

  def render_next_page
    col1 = @events.in_groups_of(3).transpose.first
    col2 = @events.in_groups_of(3).transpose.second
    col3 = @events.in_groups_of(3).transpose.last
    render json: {
        col1: render_json_col(col1),
        col2: render_json_col(col2),
        col3: render_json_col(col3),
        page: @events.next_page
    }
  end

  def render_json_col(col)
    render_to_string('docs/_json_articles_list', locals: {articles: col}, layout: false, formats: [:html])
  end

  def authorize_with_preview
    if params[:preview_secret]
      @event.preview_secret == params[:preview_secret]
    else
      authorize! :read, @event
    end
  end
end
