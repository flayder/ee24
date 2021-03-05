class Admin::CommunitiesController < Admin::BaseController
  
  def index
    @communities = Community.all
  end

  def new
    @community = Community.new
  end

  def create
    @community = Community.new(params[:community])
    @community.user = User.where("id = ? or email = ?", params[:community][:user], params[:community][:user]).first
    if @community.save
      redirect_to admin_communities_path
    else
      render "new"
    end
  end

  def edit
    @community = Community.find(params[:id])
  end

  def update
    @community = Community.find(params[:id])
    @community.user = User.where("id = ? or email = ?", params[:community][:user], params[:community][:user]).first
    if @community.update_attributes(params[:community])
      redirect_to admin_communities_path
    else
      render "edit"
    end
  end

  def destroy
    @community = Community.find(params[:id])
    @community.destroy
    redirect_to admin_communities_path
  end

end