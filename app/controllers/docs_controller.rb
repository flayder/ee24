# encoding : utf-8
class DocsController < ApplicationController
  include Modules::WithCommonLayout
  include Modules::WithViewHelper
  include Modules::WithLastModified
  include Modules::WithSidebarPhotoSlider
  cache_sweeper :doc_sweeper

  before_filter :set_section
  before_filter :find_global_rubric

  include Modules::WithDocsSection

  before_filter :login_required, :only => [:my, :new, :create, :edit, :update, :destroy]
  before_filter :authorize, :only => [:approve, :not_approved]

  def index
    set_index_meta_fields
    @docs = Doc.site(@site).approved.global_rubric(@global_rubric).by_language.order('created_at DESC')
                .paginate(page: params[:page], per_page: 15)

    @breadcrumbs = []
    @breadcrumbs.push({title: (@global_rubric.title), url: "/#{@global_rubric.link}"}) if @global_rubric.present?
    #render json: @docs
    respond_to do |format|
      format.html
      format.json {render_next_page}
      format.rss do
        generate_rss(@docs, @global_rubric.title, "#{@global_rubric.link}", '')
      end
    end

  end

  def mailru_widget
    @docs = load_mailru_widget_docs

    respond_to do |format|
      format.html do
        render layout: false
      end

      format.json do
      end
    end
  end

  def not_approved
    # TODO
    # find why @docs are not uniq
    @docs = Doc.global_rubric(@global_rubric).site(@site).not_approved.order('id DESC').uniq
    @docs = params[:editor] ? @docs.editor_generated : @docs.user_generated
    @docs = @docs.paginate(:page => params[:page], :per_page => 20)

    @meta_title = 'Неподтверждённые статьи'
    @broads = ['Неподтверждённые статьи']
    render :list
  end

  def my
    @docs = current_user.docs.joins(:rubric).site(@site).where(:doc_rubrics => {:global_rubric_id => @global_rubric.id}).order('id desc').paginate(:page => params[:page], :per_page => 20)
    @meta_title = 'Мои статьи'
    @broads = ['Мои статьи']

    respond_to do |format|
      format.html { render :list }
      format.json {render_next_page}
    end

  end

  #/:global_rubtic_link/:link/
  def rubric
    @docs = @rubric.docs.site(@site.id).approved.by_language.order('id DESC')
                .paginate(page: params[:page], per_page: 14)
    set_rubric_meta_fields
    @broads = [[@global_rubric.title, "/#{@global_rubric.link}/"], @rubric.title]
    @breadcrumbs = []
    @breadcrumbs.push({title: (@global_rubric.title), url: "/#{@global_rubric.link}"}) if @global_rubric.present?
    @breadcrumbs.push({title: (@rubric.title), url: "/#{@global_rubric.link}/#{@rubric.link}"}) if @rubric.present?
    #render json: @docs
    respond_to do |format|
      format.html {render :index}
      format.json {render_next_page}
      format.rss do
        generate_rss(@docs, @global_rubric.title, "#{@global_rubric.link}/#{@rubric.link}", @rubric.title)
      end
    end
  end

  def new
    @doc = @site.docs.new
    @doc.photos.build
    @doc.rubric = @global_rubric.doc_rubrics.first

    @rubrics = [@global_rubric]
    @broads = ['Добавление статьи']
    @meta_title = ['Добавление статьи']
  end

  def create
    @doc = @site.docs.build
    @doc.doc_rubric_id = params[:doc][:doc_rubric_id]

    @doc.assign_attributes params[:doc], :as => can?(:manage, @doc) ? :admin : :default
    @doc.user = User.where("id = ? or email = ?", params[:doc][:user_id], params[:doc][:user_id]).first || current_user
    @doc.created_at ||= Time.current

    @broads = ['Добавление статьи']
    @meta_title = ['Добавление статьи']

    if @doc.save
      Resque.enqueue(Mailer, 'DocMailer', :doc_created, @doc.id)
      flash[:notice] = 'Статья успешно создана.'
      redirect_to :action => :index
    else
      @doc.photos = [@doc.photos.build]
      @rubrics = [@global_rubric]
      render :action => :new
    end
  end

  def edit
    @doc = @site.docs.find_by_id params[:id]
    return render_404 unless @doc

    authorize! :edit, @doc
    @doc.photos.build if @doc.photos.blank?
    @rubrics = [@global_rubric]
    @broads = 'Редактирование статьи'
    @meta_title = 'Редактирование статьи'
  end

  def update
    @doc = @site.docs.find_by_id params[:id]
    return render_404 unless @doc
    authorize! :update, @doc

    params[:doc][:user_id] = User.where("id = ? or email = ?", params[:doc][:user_id], params[:doc][:user_id]).first.try(:id) || @doc.user.id

    change_approve_status = (@doc.approved ? "1" : "0") != params[:doc][:approved]

    if @doc.update_attributes(params[:doc], as: (can?(:update, @doc) ? :admin : :default))
      flash[:notice] = 'Статья успешно обновлена'

      if change_approve_status
        Resque.enqueue(Mailer, 'DocMailer', @doc.approved? ? :doc_approved : :doc_not_approved, @doc.id)
      else
        Resque.enqueue(Mailer, 'DocMailer', :doc_changed, @doc.id)
      end

      if @doc.approved?
        redirect_to @doc.url
      else
        redirect_to action: :index
      end
    else
      @rubrics = [@global_rubric]
      @broads = 'Редактирование статьи'
      @meta_title = 'Редактирование статьи'
      render action: :edit
    end
  end

  def destroy
    doc = @site.docs.find_by_id params[:id]
    return render_404 unless doc
    authorize! :destroy, doc
    flash[:notice] = 'Статья удалена' if doc.destroy
    url = (request.referer.present? && !request.referer.include?(doc.url)) ? :back : "/#{doc.global_rubric.link}"
    redirect_to url
  end

  def show
    @doc = MigratedDocFinder.find_doc(@rubric, params[:id]) if @global_rubric.link == 'news' && @doc

    unless @doc
      @doc = @site.docs.find_by_id(params[:id])
      return render_404 unless @doc

      authorize_with_preview
      return if performed?
      unless request.path.gsub(/\..*/, '') == @doc.url
        redirect_to(@doc.approved ? @doc.url : @doc.preview_secret_url, status: :moved_permanently) and return
      end
    end

    @docs = @site.docs.news.where('id != ?', @doc.id).order('id DESC').limit(10)
    @meta_title ||= [@site.domain + ' ' + @site.portal_title, @global_rubric.title, @rubric.title, @doc.title]
    @broads = [[@global_rubric.title, "/#{@global_rubric.link}"], [@rubric.title, "/#{@global_rubric.link}/#{@rubric.link}"], @doc.title]
    @meta_keywords ||= @doc.tags.pluck(:name).join(', ')
    @meta_description ||= @doc.annotation

    set_last_modified @doc unless logged_in?

    @doc.inc_page_views! @site
    #render json: @docs
    respond_to do |format|
      format.html
      format.rss {
        redirect_to @doc.url if !@doc.yandex_zen
      }
    end
  end

  def comments
    @doc = @site.docs.where(is_commentable: true).find_by_id(params[:id])
    return render_404 unless @doc
    # authorize! :read, @doc
    # @meta_title ||= [@site.domain + ' ' + @site.portal_title, @global_rubric.title, @rubric.title, "Комментарии материала: #{@doc.title}"]
    # @broads = [[@global_rubric.title, "/#{@global_rubric.link}"], [@rubric.title, "/#{@global_rubric.link}/#{@rubric.link}"], [@doc.title, @doc.url], 'Комментарии']
    redirect_to @doc.url, :status => :moved_permanently
  end

  def approve
    @doc = Doc.site(@site.id).find_by_id(params[:id])
    return render_404 unless @doc
    @doc.approve!
    Resque.enqueue(Mailer, 'DocMailer', :doc_approved, @doc.id)
    redirect_to action: :not_approved
  end

  def date
  end

  private

  def authorize
    authorize! :manage, Doc
  end

  def find_global_rubric
    @global_rubric = @section.rubrics(params[:global_rubric]).first!
    @sub_rubrics = @global_rubric.doc_rubrics
  end

  def authorize_with_preview
    if params[:preview_secret]
      if @doc.preview_secret != params[:preview_secret]
        return render_404
      end
    else
      authorize! :read, @doc
    end
  end

  def layout_params
    { rss_links_folder: :docs }
  end

  def set_index_meta_fields
    @meta_title = [@global_rubric.title] if @meta_title.blank?
    @broads = [@global_rubric.title]
  end

  def set_rubric_meta_fields
    @meta_description = @rubric.meta_description(@site)
    @meta_keywords = @rubric.meta_keywords(@site)
    @meta_title = @rubric.meta_title(@site) if @meta_title.blank?
    @meta_title = [@global_rubric.title, @rubric.title] if @meta_title.blank?
    @seo ||= @rubric.seo(@site)
    @seo_about ||= @rubric.seo_about(@site)
    @seo_sub_text ||= @rubric.seo_sub_text(@site)
  end

  def load_mailru_widget_docs
    docs = @site.docs.mailru_widget
    docs.sort_by { |d| -d.views_rating }.first(4)
  end

  def render_next_page
    col1 = @docs.in_groups_of(3).transpose.first
    col2 = @docs.in_groups_of(3).transpose.second
    col3 = @docs.in_groups_of(3).transpose.last
    render json: {
        col1: render_json_col(col1),
        col2: render_json_col(col2),
        col3: render_json_col(col3),
        page: @docs.next_page
    }
  end

  def render_json_col(col)
    render_to_string('_json_articles_list', locals: {articles: col}, layout: false, formats: [:html])
  end
end
