#encoding: utf-8
class Admin::MainBlocksController < Admin::BaseController
  authorize_resource :main_block
  cache_sweeper :main_block_sweeper

  def index
    @search = MainBlock.site(@site).metasearch params[:search]
    @main_blocks = @search.page params[:page]
  end

  def new
    @main_block = @site.main_blocks.build params[:main_block], as: :admin
    @rubrics = rubric_for_doc_type(@main_block.doc_type)
    setup_main_block_rubrics
  end

  def create
    @main_block = @site.main_blocks.new params[:main_block], as: :admin

    if @main_block.save
      redirect_to admin_main_blocks_path, notice: 'Блок главной успешно создан'
    else
      @rubrics = rubric_for_doc_type(@main_block.doc_type)
      setup_main_block_rubrics
      render action: :new
    end
  end

  def edit
    @main_block = @site.main_blocks.find params[:id]
    @rubrics = rubric_for_doc_type(@main_block.doc_type)
    setup_main_block_rubrics
  end

  def update
    @main_block = @site.main_blocks.find params[:id]

    if @main_block.update_attributes params[:main_block], as: :admin
     redirect_to action: :index, notice: 'Блок главной успешно обновлен'
    else
     render action: :edit
    end
  end

  def destroy
    @site.main_blocks.find(params[:id]).destroy
    redirect_to action: :index
  end

  private
  def rubric_for_doc_type doc_type
    case doc_type
    when 'Doc'
      @site.doc_global_rubrics
    when 'Event'
      @site.event_rubrics
    when 'ExternalDoc'
      @site.external_doc_rubrics
    end
  end

  def setup_main_block_rubrics
    #rubrics = @main_block.doc_type == 'Doc' ? @site.doc_rubrics : @rubrics
    rubrics = case @main_block.doc_type
      when 'Doc' then @site.doc_rubrics
      else  @rubrics
    end

    rubrics.each do |rubric|
      next if @main_block.main_block_rubrics.detect { |mbr| mbr.rubric == rubric }

      @main_block.main_block_rubrics.build do |main_block_rubric|
        main_block_rubric.rubric = rubric
      end
    end
  end
end
