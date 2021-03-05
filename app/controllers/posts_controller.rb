class PostsController < ApplicationController

  load_and_authorize_resource
  skip_authorize_resource only: [:create]

  before_filter :find_community, only: [:show, :edit, :update, :destroy]
  before_filter :find_category, only: [:show, :edit, :update, :destroy]

  def show
    @post = Post.find(params[:id])
    @meta_title = "#{@post.title} | #{@community.name} |  #{@category.name}"
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    @post = Post.new(params[:post])
    @post.user = current_user
    authorize! :create, @post
    if @post.save
      redirect_to category_community_path(@post.community.category, @post.community)
    else
      render "new"
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      redirect_to category_community_post_path(@community.category, @community, @post)
    else
      render "edit"
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to category_community_path(@category, @community)
  end

  private

  def find_community
    @community = Community.find(params[:community_id])
  end

  def find_category
    @category = Category.find(params[:category_id])
  end

end
