# encoding : utf-8
class Admin::DictionaryObjectsController < Admin::BaseController
  authorize_resource :dictionary_object

  def index
    @search = DictionaryObject.site(@site).metasearch(params[:search])
    @dictionary_objects = @search.page(params[:page])
  end

  def new
    @dictionary_object = DictionaryObject.new(:rubric_id => params[:rubric_id])    
  end

  def create
    @dictionary_object = @site.dictionary_objects.new(params[:dictionary_object])
    if @dictionary_object.save
      redirect_to admin_dictionary_objects_path, :notice => 'Словарная статья успешно создана'
    else
      render :action => :new
    end
  end

  def edit
    @dictionary_object = @site.dictionary_objects.find(params[:id])
  end

  def update
    @dictionary_object = @site.dictionary_objects.find(params[:id])
    
    if @dictionary_object.update_attributes(params[:dictionary_object])
      redirect_to :action => :index, :notice => 'Словарная статья успешно обновлена'
    else
      render :action => :edit
    end
  end

  def destroy
    @site.dictionary_objects.find(params[:id]).destroy
    redirect_to :action => :index
  end

  def toggle_approved
    @dictionary_object = @site.dictionary_objects.find params[:id]
    @dictionary_object.toggle!(:approved)

    redirect_to :back
  end
end