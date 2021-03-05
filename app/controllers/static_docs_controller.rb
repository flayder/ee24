# encoding : utf-8
class StaticDocsController < ApplicationController
  include Modules::WithCommonLayout

  def show
    @doc = @site.static_docs.active.find_by_link! params[:id]

    @meta_title = ["#{@site.portal_title} #{@site.domain}", @doc.title]
    @meta_description = @doc.meta_description
    @meta_keywords = @doc.meta_keywords

    @broads = [@doc.title]
  end

  def vk_poll
    render :layout => false
  end

  private
  def layout_params
    {}
  end
end
