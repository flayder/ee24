# encoding : utf-8
class MainController < ApplicationController
  include Modules::WithCommonLayout
  include Modules::WithSidebarPhotoSlider

  def rss
    @docs = Doc.for_rss.for_news_rss.site(@site.id).order('created_at DESC').limit(20)

    @xml = {}
    @xml["title"] = @site.portal_title
    @xml["link"] = "https://" + @site.domain
    @xml["description"] = @site.portal_title
    @xml["created_at"] = @docs.first.try(:created_at)

    headers["Content-Type"] = "application/xml; charset=utf-8"
    render layout: false, template: "application/rss"
  end

  def rambler_rss
    @docs = Doc.for_rss.for_news_rss.site(@site.id).order('created_at DESC').limit(20)
    headers["Content-Type"] = "application/xml; charset=utf-8"
    render layout: false, template: "application/rambler_rss"
  end

  def yandex_rss
    @docs = load_rss_docs
    headers["Content-Type"] = "application/xml; charset=utf-8"
    if @docs.any?
      render layout: false, template: "application/yandex_rss"
    else
      redirect_to root_path
    end
  end

  def mailru_rss
    galleries = Gallery.site(@site).last_week.approved.order('created_at DESC')
    docs = Doc.site(@site).approved.last_week.for_rss.order('created_at DESC')
    docs = docs.for_news_rss unless @site.voronezh?
    @docs = (galleries + docs).sort_by{ |a| a.created_at }.reverse
    headers["Content-Type"] = "application/xml; charset=utf-8"
    if @docs.any?
      render layout: false, template: "application/mailru_rss"
    else
      redirect_to root_path
    end
  end

  def zen_rss
    @docs = Doc.site(@site).approved.for_rss.last_week.where(yandex_zen: true).order('created_at DESC')
    headers["Content-Type"] = "application/xml; charset=utf-8"
  end

  def index
    # @docs = @site.docs.approved.where(top_main: true).by_language.order("created_at DESC").first(8)
    @news = Doc.news.today.by_language.order('RAND()').first(8)
    @news_week = Doc.news.last_week.by_language.order('RAND()').first(8)
    @news_month = Doc.news.last_month.by_language.order('RAND()').first(8)
    # @popular_month = Doc.news.popular_by_month.by_language.first(6)
    @events = @site.events.by_language.order("created_at DESC").main.first(4)
    @photo_galleries = @site.galleries.approved.where(not_on_main: false).order("created_at DESC").limit(9)
    # @attractions = @site.dictionaries.find_by_link(:attractions).dictionary_objects.sample(2)
    # @doc_announce = DocAnnounce.last
    @articles = @site.docs.without_news.where(main: true).by_language.first(12)
    @questions = Question.by_language.order('created_at DESC').paginate(page: params[:page], per_page: 3)
    #@tags = @site.tags
    @authors = @site.doc_global_rubrics.find_by_link('news').doc_rubrics.find_by_link("authors").docs.approved.by_language.first(3)
    #@real_cat = @site.doc_global_rubrics.find_by_link('realty').doc_rubrics
    @realties = @site.docs.per_realty 3
    @job_items = Vacancy.approved.order("created_at DESC").includes(:user).first(4)
    @job_items_actual = Vacancy.actual.approved.order("created_at DESC").includes(:user).where("id NOT IN (?)", @job_items.try(:map, &:id))
    @catalogs = @site.catalog_rubrics.roots.order('position, title')
    #@main_blocks = @site.main_blocks.order(:position)
    # arr = []
    # @realties.each do |first, array|
    #   arr.push array
    # end
    #render json: @catalogs.length
  end

  private
  def load_rss_docs
    docs = Doc.site(@site).approved.for_rss.last_week.order('created_at DESC')
    if @site.voronezh?
      docs
    else
      docs.for_news_rss
    end
  end

  def layout_params
    { rss_links_folder: :main }
  end
end
