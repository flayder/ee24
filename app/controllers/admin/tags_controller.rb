# encoding : utf-8
class Admin::TagsController < ApplicationController
  layout 'admin'

  before_filter :check_access
  before_filter :find_counts, except: [:destroy, :remove_from_doc]

  def index
    #тут только используемые теги
    conditions = params[:letter] ? ['tags.name like ?', "#{params[:letter]}%"] : true

    @letters = ('а'..'я').to_a + ('a'..'z').to_a + (0..9).to_a

    tags = {}
    %w(Doc Gallery Catalog DictionaryObject).each do |taggable_type|
      tags[taggable_type] = ActsAsTaggableOn::Tag.site(@site).joins(:taggings).group('taggings.tag_id').where(conditions).where(taggings: {taggable_type: taggable_type})
    end
    tags = tags['Doc'] & tags['Gallery'] & tags['Catalog'] & tags['DictionaryObject']

    @search = ActsAsTaggableOn::Tag.where(id: tags.map(&:id)).metasearch params[:search]

    @tags = @search.select{|tag| tag.has_description?}.paginate(:page => params[:page], :per_page => 100)
  end

  def without
    taggable_type = params[:taggable_type]
    tags = ActsAsTaggableOn::Tag.without(taggable_type, @site)
    @search = tags.order('name').metasearch params[:search]
    @tags = @search.paginate(page: params[:page], per_page: 100)

    render template: 'admin/tags/empty'
  end

  def without_description
    tags = ActsAsTaggableOn::Tag.site(@site)
    seo_paths = Seo.site(@site).where(path: tags.map{|t| URI::encode(t.url)}).pluck(:path)
    tag_names = seo_paths.map{|p|URI::decode(p.gsub!('/tags/', ''))}
    tags = tags.where('link not in (?)', tag_names).order('name')
    @search = tags.metasearch params[:search]
    @tags = @search.paginate(page: params[:page], per_page: 100)

    render template: 'admin/tags/empty'
  end

  def show
    @tag = ActsAsTaggableOn::Tag.site(@site).find params[:id]
    authorize! :read, @tag
  end

  def new
    @tag = ActsAsTaggableOn::Tag.new
    @tag.site = @site
    authorize! :create, @tag
    #@tag.seos.build(:site_id => @site.id)
  end

  def create
    @tag = ActsAsTaggableOn::Tag.new(params[:acts_as_taggable_on_tag], as: :admin)
    @tag.site = @site
    #@tag.seos.map { |s| s.site_id = @site.id }

    authorize! :create, @tag

    if @tag.save
      redirect_to admin_tags_url, :notice => 'Тег создан'
    else
      render :action => :new
    end
  end

  def edit
    @tag = ActsAsTaggableOn::Tag.site(@site).includes(:taggings).find(params[:id])
    authorize! :edit, @tag

    #@tag.seos.find_or_initialize_by_site_id(@site.id)
  end

  def update
    @tag = ActsAsTaggableOn::Tag.site(@site).where(link: params[:id]).first
    authorize! :update, @tag

    if @tag.update_attributes(params[:acts_as_taggable_on_tag], as: :admin)
      redirect_to admin_tag_url(@tag.id), :notice => 'Тег обновлён'
    else
      render :action => :edit
    end
  end

  def destroy
    @tag = ActsAsTaggableOn::Tag.site(@site).find params[:id]
    authorize! :destroy, @tag

    @tag.destroy
    redirect_to admin_tags_url, :notice => 'Тег успешно удалён'
  end

  #убрать
  def remove_from_doc
    unless %w(Doc Event Gallery DictionaryObject Catalog).include?(params[:model])
      render_404
      return false
    end

    tag = ActsAsTaggableOn::Tag.site(@site).find(params[:id])
    doc = params[:model].constantize.find(params[:doc_id])

    doc.tag_list.remove(tag.name)
    doc.save

    redirect_to admin_tag_url(tag.id)
  end

  private

  def find_counts
    #кол-во рабочих
    tags = {}
    %w(Doc Gallery Catalog DictionaryObject).each do |taggable_type|
      tags[taggable_type] = ActsAsTaggableOn::Tag.site(@site).joins(:taggings).group('taggings.tag_id').where(taggings: {taggable_type: taggable_type})
    end
    @in_work_cnt = (tags['Doc'] & tags['Gallery'] & tags['Catalog'] & tags['DictionaryObject']).select{|tag| tag.has_description?}.size
    #@in_work_cnt = ActsAsTaggableOn::Tag.select('tags.*, count(taggings.id) as cnt').site(@site).joins(:taggings).group('taggings.tag_id').select{|tag| tag.has_description?}.size
    #кол-во без описания/без материалов - остальные
    #@empty_cnt = ActsAsTaggableOn::Tag.site(@site).count - @in_work_cnt
    #без статей
    @without_doc_cnt = ActsAsTaggableOn::Tag.without('Doc', @site).count
    #без фотогалерей
    @without_photo_cnt = ActsAsTaggableOn::Tag.without('Gallery', @site).count
    #без компаний
    @without_catalog_cnt = ActsAsTaggableOn::Tag.without('Catalog', @site).count
    #без словарных статей
    @without_dict_cnt = ActsAsTaggableOn::Tag.without('DictionaryObject', @site).count
    #без описания
    @without_descr_cnt = ActsAsTaggableOn::Tag.site(@site).select{|tag| !tag.has_description?}.size
  end

  def check_access
    authorize! :manage, ActsAsTaggableOn::Tag
  end
end
