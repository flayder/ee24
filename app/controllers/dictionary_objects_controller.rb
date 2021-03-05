# encoding : utf-8
class DictionaryObjectsController < ApplicationController
  include Modules::WithCommonLayout
  include Modules::WithSidebarPhotoSlider

  before_filter :set_section
  before_filter :find_dictionary
  before_filter :find_rubric, :only => [:rubric, :show]

  before_filter :get_rubric_ads, :only => [:rubric, :show]
  before_filter :get_dictionary_ads
  before_filter :get_ads

  before_filter :assign_letters
  before_filter :assign_broads

  def index
    @dictionary_objects = @dictionary.dictionary_objects.includes(:rubric).order('title ASC').approved.page(params[:page])
    @broads = [@dictionary.title]

    respond_to do |format|
      format.html do
      end

      format.rss do
        generate_rss(@dictionary_objects, @dictionary.title, "dictionaries/#{@dictionary.link}")
      end
    end
  end

  def show
    authorize! :read, @dictionary_object

    @meta_title ||= "#{@dictionary_object.title} / #{@dictionary.title}"
    @broads += [[@dictionary_object.rubric.title, dictionary_objects_rubric_path(:link => @dictionary_object.rubric.dictionary.link, :id => @dictionary_object.rubric.id)], @dictionary_object.title]
  end

  def rubric

    @dictionary_objects = @rubric.dictionary_objects.includes(:rubric).order('title ASC').approved.page(params[:page])
    @broads << @rubric.title

    @seo ||= @rubric.seo(@site)
    @seo_about ||= @rubric.seo_about(@site)
    @seo_sub_text ||= @rubric.seo_sub_text(@site)

    respond_to do |format|
      format.html do
        render :rubric
      end

      format.rss do
        generate_rss(@dictionary_objects, @dictionary.title, "dictionaries/#{@dictionary.link}/rubric/#{@rubric.id}", @rubric.title)
      end
    end
  end

  def letter
    @dictionary_objects = @dictionary.dictionary_objects.order('title ASC').approved.where(:letter => params[:letter]).page(params[:page])
    @broads << params[:letter]
    render :index
  end

  private
  def find_dictionary
    @dictionary = @site.dictionaries.where(:link => params[:link]).first!
  end

  def find_rubric
    if params[:action] == 'show'
      @dictionary_object = @dictionary.dictionary_objects.find(params[:id])
      @rubric = @dictionary_object.rubric
    else
      @rubric = @dictionary.rubrics.find(params[:id])
    end
    set_rubric_ads(@rubric)
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def get_dictionary_ads
    set_rubric_ads(@dictionary)
  end

  def get_rubric_ads
    set_rubric_ads(@rubric)
  end

  def assign_letters
    @letters = @dictionary.dictionary_objects.select('letter').uniq.order('letter ASC').pluck(:letter)
  end

  def assign_broads
    @broads = [[@dictionary.title, dictionary_objects_url(:link => @dictionary.link)]]
  end
end
