class CommunitiesController < ApplicationController

  before_filter :find_category, only: [:index, :show, :edit, :update]

  def index
    @communities = @category.communities
  end

  def show
    @community = Community.find(params[:id])
    @posts = @community.posts.order("created_at DESC")
    @meta_title = "#{@community.name} | #{@category.name}"
  end

  def new
    @community = Community.new
  end

  def edit
    @community = Community.find(params[:id])
  end

  def create
    @community = Community.new(params[:community])
    @community.user = current_user
    if @community.save
      redirect_to category_community_path(@community.category, @community)
    else
      render 'new'
    end
  end

  def update
    @community = Community.find(params[:id])
    if @community.update_attributes(params[:community])
      redirect_to category_community_path(@category, @community)
    else
      render 'edit'
    end
  end

  private

  def find_category
    @category = Category.find(params[:category_id])
  end

end
