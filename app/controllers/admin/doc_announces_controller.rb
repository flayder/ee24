class Admin::DocAnnouncesController < Admin::BaseController
  
  def create
    @doc_announce = DocAnnounce.create(params[:doc_announce])
    redirect_to admin_ad_codes_path
  end

end