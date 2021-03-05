# encoding : utf-8
class WeatherController < ApplicationController
  include Modules::WithCity
  include Modules::WithCommonLayout

  before_filter :set_section, :get_ads

  layout 'application'

  def index
    @broads = ['Погода']
    if @seo
      @meta_title = @seo.title
      @meta_description = @seo.description
      @meta_keywords = @seo.keywords
    end
  end

  private
  def layout_params
    {}
  end

end
