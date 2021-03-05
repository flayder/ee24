# encoding : utf-8

class MapController < ApplicationController

  include Modules::WithCommonLayout
  include Modules::WithCity
  include ApplicationHelper

  before_filter :set_coords
  before_filter :initialize_rubrics, :only => [:google, :index]
  before_filter :set_section, :get_ads

  respond_to :json

  def index
    set_search_broads
    set_index_meta_fields @seo if @seo

    self.send Settings.portal_map_provider

    @places = Catalog.approved.site(@site.id).where('lat is not null and lng is not null').limit(500)
  end

  def show
    @place = Catalog.find_by_id(params[:id])
    return render_404 unless @place
    @places = [@place]
    @broads = [@place.title]

    render_map Settings.portal_map_provider
  end

  def search
    respond_to do |format|
      format.js do
        if Settings.portal_map_provider == 'google'
          search_for_google if params[:address].present?
          render :template => 'map/load_google_marks.js.erb'
        else
          respond_with search_by_address if params[:address].present?
        end
      end
    end
  end

  def load_marks
    if Settings.portal_map_provider == 'google'
      respond_to do |format|
        format.js {
          load_google_marks
        }
        end
    else
      load_yandex_marks
    end
  end

  def load_google_marks
    if params[:rubric_id].present?
      @rubric = @site.catalog_rubrics.find params[:rubric_id]
      @places = @rubric.catalogs.for_map.site(@site.id)
      @places_json = @places.to_gmaps4rails if @places.present?
    end

    render :template => 'map/load_google_marks.js.erb', :content_type => 'text/javascript'
  end

  def load_yandex_marks
    if params[:rubric_id].present?
      @rubric = @site.catalog_rubrics.find params[:rubric_id]
      @places = @rubric.catalogs.for_map.site(@site.id)
    end

    respond_with @places
  end

  def get_map_rubrics
    if params[:rubric_id] && params[:rubric_id] =~ /^\d+$/
      global_rubric = @site.catalog_rubrics.find params[:rubric_id]

      if global_rubric
        @rubrics = @site.catalog_rubrics.find global_rubric.children.pluck(:id)
      end
    else
      @rubrics = []
    end
    render :json => @rubrics.map { |r| [r.id, r.title] }
  end

  private
  def initialize_rubrics
    if @site.has_section?(:catalog)
      if params[:rubric_id]
        @rubric = @site.catalog_rubrics.find params[:rubric_id]
      else
        @rubric = @site.catalog_rubrics.where(title: 'Отдых. Спорт. Туризм')
      end
      @rubrics = @site.catalog_rubrics.roots
    end
  end

  def google
    search_for_google if (params[:address].present? && @site.has_section?(:catalog))
    render :action => :google
  end

  def yandex
    search_by_address if (params[:address].present? && @site.has_section?(:catalog))
  end

  def search_for_google
    @places = approved_places(params[:address]).select { |p| p.lat? && p.lng? }
    @places_json = @places.present? ? @places.to_gmaps4rails : geocode_places(params[:address])
  end

  def search_by_address
    @places = approved_places(params[:address]).select { |p| p.lat.present? && p.lng.present? }

    if @places.any?
      @found = true

      if @places.size == 1
        @city_latitude = @places.first.lat
        @city_longitude = @places.first.lng
      end
    else
      request_str = "#{@city.title}, #{params[:address]}"

      result = Geocoder.search(request_str).select{ |r| r.precision != 'other'}
      if result.present?
        @found = true
        description = result.first.address
        precision = 0.00005
        latitude, longitude = result.first.coordinates
        @places = Catalog.where(['approved=true and lat between ? and ? and lng between ? and ?', latitude - precision, latitude + precision, longitude - precision, longitude + precision])
        @places.each do |place|
          description += "<p><a href='#{place.url(@site)}'>#{place.title}</a> (#{place.gmaps4rails_address})</p>"
        end
      end
    end

    @places
  end

  def set_coords
    @city_latitude = @city.lat
    @city_longitude = @city.lng
  end

  def set_search_broads
    @broads = [["Карта #{@city.induced_title}", '/map'], 'Поиск']
    @broads << params[:city] if params[:city]
    @broads << params[:address] if params[:address]
  end

  def approved_places address
    Catalog.search(conditions: { title: Riddle.escape(address) }, with: { approved: true, site_id: @site.id } )
  end

  def geocode_places address
    geocode_result = Gmaps4rails.geocode(address).first

    if geocode_result.present?
      places = @site.catalogs.approved.close_to(geocode_result[:lat], geocode_result[:lng], 0.00005)
      places.to_gmaps4rails
    else
      []
    end
  end

  def render_map map_provider
    case map_provider
    when 'yandex'
      render :index
    when 'google'
      @places_json = @places.to_gmaps4rails
      render :google
    end
  end

  def set_index_meta_fields seo
    @meta_title = seo.title
    @meta_description = seo.description
    @meta_keywords = seo.keywords
  end
end
