# encoding : utf-8

class AdSurfacesController < ApplicationController
  include Modules::WithCommonLayout
  before_filter :handle_params, except: :show
  respond_to :json

  def index
    @streets = Street.city(@city.id).joins(:ad_surfaces).order('title').uniq
    init_ad_variables
    @meta_title ||= ["Рекламные поверхности #{@city.induced_title}"]
    @broads = ["Рекламные поверхности #{@city.induced_title}"]
  end

  def show
    @ad_surface = AdSurface.city(@city.id).find params[:id]
    coords = [@ad_surface.lat, @ad_surface.lng]
    template = render_to_string(partial: "ad_surfaces/ad_surface_popup", locals: {ad: @ad_surface})
    render json: { template: template, coordinates: coords }
  end

  def search
    load_streets_and_ad_formats
    @map_surfaces = load_map_surfaces
    template = @map_surfaces.map{ |ad_surface| render_to_string(partial: "ad_surfaces/ad_surface", locals: {ad_surface: ad_surface}) }
    render json: { template: template, surface: @map_surfaces }
  end

  private
  def handle_params
    params[:page] ||= 1
    params[:ad_surface] ||= {}
    params[:ad_surface].delete_if { |k, v| v.empty? }
    @order = params[:ad_surface][:ad_agency_id].present? ? 'id' : 'street_id'
  end

  def load_streets_and_ad_formats
    if params[:ad_surface][:ad_agency_id]
      init_agency_streets_and_ad_formats params[:ad_surface][:ad_agency_id]
    else
      init_city_streets_and_ad_formats
    end
  end

  def init_agency_streets_and_ad_formats agency_id
    @streets = Street.city(@city.id).ad_agency(agency_id).order('title').uniq
    @ad_formats = AdFormat.joins(:ad_surfaces).where(ad_surfaces: { city_id: @city.id, ad_agency_id: agency_id }).uniq
    params[:ad_surface].delete(:street_id) if params[:ad_surface][:street_id].present? && @streets.find { |s| s.id == params[:ad_surface][:street_id].to_i }
  end

  def init_city_streets_and_ad_formats
    @streets = Street.city(@city.id).joins(:ad_surfaces).order('title').uniq
    @ad_formats = AdFormat.joins(:ad_surfaces).where(ad_surfaces: { city_id: @city.id }).uniq
  end

  def apply_ad_surface_search(surfaces)
    surfaces = surfaces.where(ad_agency_id: params[:ad_surface][:ad_agency_id]) unless params[:ad_surface][:ad_agency_id].blank?
    surfaces = surfaces.where(street_id: params[:ad_surface][:street_id]) unless params[:ad_surface][:street_id].blank?
    surfaces = surfaces.where(ad_format_id: params[:ad_surface][:ad_format_id]) unless params[:ad_surface][:ad_format_id].blank?
    surfaces
  end

  def load_map_surfaces
    if params[:from_checkbox] == '1'
      params[:ad_surface][:id] = params[:ad_surface_ids].present? ? params[:ad_surface_ids] : []
    end
    surfaces = AdSurface.city(@city.id).includes(:ad_format)
    surfaces = apply_ad_surface_search(surfaces)

    surfaces.map_surfaces.order(@order).paginate(page: params[:page], per_page: 10)
  end

  def init_ad_variables
    @ad_agencies = AdAgency.all
    @ad_formats = AdFormat.joins(:ad_surfaces).where(ad_surfaces: { city_id: @city.id }).uniq
    @map_surfaces = AdSurface.includes(:ad_agency, :street).city(@city.id)
    @map_surfaces = apply_ad_surface_search(@map_surfaces).map_surfaces
    @ad_surfaces = @map_surfaces.paginate(page: params[:page], per_page: 10)
  end
end
