# encoding : utf-8
class Admin::DictionaryRubricsController < Admin::BaseController
  authorize_resource :dictionary_rubric

  def index
    @search = DictionaryRubric.site(@site).metasearch(params[:search])
    @dictionary_rubrics = @search.page(params[:page])
  end

  def new
    @dictionary_rubric = DictionaryRubric.new(:dictionary_id => params[:dictionary_id])
  end

  def create
    @dictionary_rubric = @site.dictionary_rubrics.new(params[:dictionary_rubric])

    if @dictionary_rubric.save
      redirect_to admin_dictionary_rubrics_path, :notice => 'Рубрика успешно создана'
    else
      render :action => :new
    end
  end

  def edit
    @dictionary_rubric = @site.dictionary_rubrics.find(params[:id])
  end

  def update
    @dictionary_rubric = @site.dictionary_rubrics.find(params[:id])

    if @dictionary_rubric.update_attributes(params[:dictionary_rubric])
     redirect_to :action => :index, :notice => 'Словарная рубрика успешно обновлена'
    else
     render :action => :edit
    end
  end

  def destroy
    @site.dictionary_rubrics.find(params[:id]).destroy
    redirect_to :action => :index
  end
end
