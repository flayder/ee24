# encoding : utf-8
class Admin::CatalogsController < Admin::BaseController
  authorize_resource :catalog

  def autocomplete
    catalogs = Catalog.site(@site).select([:id, :title]).where("title like ?", "%#{params[:term].strip}%").select([:id, :title]).limit(10)
    render :json => catalogs.map { |t| { :id => t.id, :label => t.title, :value => t.title } }
  end
end
