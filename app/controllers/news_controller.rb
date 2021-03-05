# encoding : utf-8
class NewsController < ApplicationController
  include Modules::WithCommonLayout

  before_filter :find_global_rubric
  before_filter :get_popular_news, only: [:index, :show]

  def index
    find_date_and_range(params)
    set_meta_fields
    per_page = request.format == 'rss' ? 50 : 20
    @docs = if @date_range
      @site.docs.news.where(created_at: @date_range).by_language.order('created_at DESC').paginate(:page => params[:page], per_page: per_page)
    else
      @site.docs.news.by_language.order('created_at DESC').paginate(:page => params[:page], per_page: per_page)
    end
    respond_to do |format|
      format.html
      format.json { render json: {content: render_to_string('_news_list', layout: false, formats: [:html]), prev: @date.prev_day.strftime('%Y/%m/%d')} }
      format.rss do
        docs_first_group = @docs.order('created_at DESC')
        generate_rss(docs_first_group, 'Новости', "news", "Последние #{per_page} новостей")
      end
    end
  end

  def show
    set_meta_fields
    per_page = request.format == 'rss' ? 50 : 20
    doc_rubric = @site.doc_global_rubrics.find_by_link('news').doc_rubrics.find_by_link(params[:id])
    unless doc_rubric
      render_404
      return false
    end
    @docs = doc_rubric.docs.approved.by_language.paginate(page: params[:page], per_page: per_page)
    @seo ||= @rubric.seo(@site)
    respond_to do |format|
      format.html { render :index }
      format.json { render json: {content: render_to_string('_news_list', layout: false, formats: [:html]), prev: @date.prev_day.strftime('%Y/%m/%d')} }
      format.rss do
        docs_first_group = @docs.order('created_at DESC')
        generate_rss(docs_first_group, 'Новости', "news", "Последние #{per_page} новостей")
      end
    end
  end

  private

  def get_popular_news
    @popular_news = @site.docs.news.where('created_at >= ?', 4.days.ago).by_language.order("page_views desc").limit(10)
  end

  def find_global_rubric
    @global_rubric = DocGlobalRubric.where(site_id: 93, link: 'news').first!
    @sub_rubrics = @global_rubric.doc_rubrics
    @rubric = @site.doc_rubrics.find_by_link(params[:id]) if params[:id]
  end

  def set_meta_fields
    if @rubric
      @meta_description = @rubric.meta_description(@site)
      @meta_keywords = @rubric.meta_keywords(@site)
      @meta_title = @rubric.meta_title(@site) if @meta_title.blank?
      @meta_title = [@global_rubric.title, @rubric.title] if @meta_title.blank?
      @seo ||= @rubric.seo(@site)
      @seo_about ||= @rubric.seo_about(@site)
      @seo_sub_text ||= @rubric.seo_sub_text(@site)
    else
      @meta_title = [@global_rubric.title] if @meta_title.blank?
    end
  end

  def find_date_and_range(params)
    if params[:year] && params[:month] && params[:day]
      @date = "#{params[:year]}/#{params[:month]}/#{params[:day]}".to_date
      @date_range = @date.beginning_of_day..@date.end_of_day
    end
  end

end
