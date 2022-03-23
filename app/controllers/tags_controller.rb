# encoding: utf-8
class TagsController < ApplicationController
  include Modules::WithCommonLayout

  authorize_resource :tag, class: :'ActsAsTaggableOn::Tag'

  before_filter :find_tags_objects, only: [:show, :news, :docs, :afisha, :catalog, :photo, :dictionary]
  before_filter :set_branding_style, only: [:show, :news, :docs, :afisha, :catalog, :photo, :dictionary]

  def show
    @news = @news.paginate(page: 1, per_page: 12)
    @docs = @docs.paginate(page: 1, per_page: 12)
    @events = @events.paginate(page: 1, per_page: 3)
    @galleries = @galleries.paginate(page: 1, per_page: 3)
    @catalog = @catalog.paginate(page: 1, per_page: 3)
    @dictionary_objects = @dictionary_objects.paginate(page: 1, per_page: 3)
    @breadcrumbs = []
    @breadcrumbs.push({title: @tag.name, url: ""})
  end

  def news
    @news = @news.paginate(page: params[:page], per_page: 12)

    respond_to do |format|
      format.html
      format.json {render_next_page(@news)}
    end
  end

  def docs
    @docs = @docs.paginate(page: params[:page], per_page: 12)

    respond_to do |format|
      format.html
      format.json {render_next_page(@docs)}
    end
  end

  def afisha
    @events = @events.paginate(page: params[:page], per_page: 12)

    respond_to do |format|
      format.html
      format.json {render_next_page(@events)}
    end
  end

  def photo
    @galleries = @galleries.paginate(page: params[:page], per_page: 5)

    respond_to do |format|
      format.html
      format.json {
        render json: {
            col1: render_to_string('photo/_galleries_list_extended', locals: {galleries_list_extended: @galleries}, layout: false, formats: [:html]),
            page: @galleries.next_page
        }
      }
    end
  end

  def catalog
    @catalog = @catalog.paginate(page: params[:page], per_page: 12)

    respond_to do |format|
      format.html
      format.json {
        render json: {
            col1: render_to_string('shared/_companies', locals: {companies: @catalog}, layout: false, formats: [:html]),
            page: @catalog.next_page
        }
      }
    end
  end

  def dictionary
    @dictionary_objects = @dictionary_objects.paginate(page: params[:page], per_page: 12)

    respond_to do |format|
      format.html
      format.json {render_next_page(@dictionary_objects)}
    end
  end

  def autocomplete
    tags = ActsAsTaggableOn::Tag.site(@site).where("name like ?", "%#{params[:term].strip}%").select([:id, :name]).limit(10)
    render :json => tags.map { |t| { :id => t.id, :label => t.name, :value => t.name } }
  end

  private

  def set_branding_style
    brands_urls = { "Kinshperskiy pivovar" => "pivovar", "Kinshperskiy-pivovar" => "pivovar", "Restoran-U-Zajice" => "pivovar",
                    "MenHouse"=> "menhouse", "lvtv" => "lvtv", 'radio-vmeste' => 'radio-vmeste', 'rufm' => 'rufm' }
    @css_tag = "branding "+brands_urls[@tag.link] if brands_urls.keys.include?(@tag.link)
    @branding_logo = "__#{@tag.link.downcase.gsub(" ","_")}"
  end

  def check_url_case
    if CGI::unescape(request.path) != @tag.url
      redirect_to @tag.url, status: :moved_permanently
    end
  end

  def objects_for_tag(model)
    model.site(@site.id).approved.tagged_with(@tag.name, any: true).includes(:tags).where(tags: {site_id: @site.id}).order("#{model.name.tableize}.id DESC")
  end

  def find_tags_objects
    @tag = ActsAsTaggableOn::Tag.site(@site).where('link = ? or name = ?', params[:id] || params[:tag_id], params[:id] || params[:tag_id]).first!

    @news = objects_for_tag(Doc).where(doc_rubric_id: @site.doc_global_rubrics.find_by_link('news').doc_rubrics.pluck(:id))
    @docs = objects_for_tag(Doc).where(doc_rubric_id: @site.doc_global_rubrics.where(link: ["travel", "immigration", "realty", "magazine"]).order("id DESC").map(&:doc_rubrics).flatten.map(&:id))
    @events = objects_for_tag(Event)
    @catalog = objects_for_tag(Catalog)
    @galleries = objects_for_tag(Gallery)
    @dictionary_objects = objects_for_tag(DictionaryObject)

    @meta_title ||= "#{@site.try(:city).try(:title) || @site.portal_title}: материалы с тегом \"#{@tag.name}\""
    @broads = ["Статьи с тегом «#{@tag.name}»"]
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def render_next_page(items)
    list = items.in_groups_of(3).transpose
    render json: {
      col1: render_json_col(list.first),
      col2: render_json_col(list.second),
      col3: render_json_col(list.last),
      page: items.next_page
    }
  end

  def render_json_col(col)
    render_to_string('docs/_json_articles_list', locals: {articles: col}, layout: false, formats: [:html])
  end

end
