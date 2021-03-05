#encoding: utf-8
class Admin::FooterBlocksController < Admin::BaseController
  authorize_resource :footer_block

  def index
    @footer_blocks = FooterBlock.order(created_at: :desc)
  end

  def edit
    @footer_block = FooterBlock.find(params[:id])
  end

  def update
    @footer_block = FooterBlock.find(params[:id])

    if @footer_block.update_attributes params[:footer_block]
      redirect_to action: :index
    else
     render action: :edit
    end
  end
end
