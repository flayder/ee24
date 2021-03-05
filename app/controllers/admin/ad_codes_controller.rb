# encoding : utf-8
class Admin::AdCodesController < Admin::BaseController
  authorize_resource :ad_code
  before_filter :assign_ad_section, only: [:list, :new]

  def index
    @search = AdCode.site(@site).metasearch(params[:search])
    @ad_codes = @search.page(params[:page])
    @doc_announce = DocAnnounce.last
  end

  #коды 3-х типов для рубрики или страницы?
  def list
    @ad_codes = AdCode.site(@site.id).where(ad_section_id: params[:ad_code][:ad_section_id], ad_section_type: params[:ad_code][:ad_section_type])
  end

  #список секций разделов со ссылками на настройку баннеров
  def rubrics
    @sections = @site.site_sections.order('sections.with_rubrics desc').includes(:section)
  end

  #список рубрик раздела или подрубрик рубрики
  def section
    @section = @site.site_sections.where('sections.with_rubrics = true').includes(:section).find(params[:section_id])
    if @section.section.controller == 'dictionary_objects'
      @dictionaries = @site.dictionaries.includes(:rubrics)
    end
  end

  def new
    @ad_code = AdCode.new(params[:ad_code], as: :admin)
  end

  def create
    @ad_code = AdCode.new(params[:ad_code], as: :admin)
    @ad_code.site_id = @site.id
    if @ad_code.save
      flash[:notice] = 'Баннер сохранён'
      url = @ad_code.ad_section.present? ? list_admin_ad_codes_url(:ad_code => {:ad_section_id => @ad_code.ad_section_id, :ad_section_type => @ad_code.ad_section_type}) : admin_ad_codes_url
      redirect_to url
    else
      render :action => :new
    end
  end

  def edit
    @ad_code = AdCode.site(@site.id).find(params[:id])
  end

  def update
    @ad_code = AdCode.site(@site.id).find(params[:id])
    if @ad_code.update_attributes(params[:ad_code], as: :admin)
      flash[:notice] = 'Баннер сохранён'
      url = @ad_code.ad_section.present? ? list_admin_ad_codes_url(:ad_code => {:ad_section_id => @ad_code.ad_section_id, :ad_section_type => @ad_code.ad_section_type}) : admin_ad_codes_url
      redirect_to url
    else
      render :action => :edit
    end
  end

  def destroy
    @ad_code = AdCode.site(@site.id).find(params[:id])
    if @ad_code.destroy
      flash[:notice] = 'Баннер удалён'
    end
    url = @ad_code.ad_section.present? ? list_admin_ad_codes_url(:ad_code => {:ad_section_id => @ad_code.ad_section_id, :ad_section_type => @ad_code.ad_section_type}) : admin_ad_codes_url
    redirect_to url
  end

  private
  def assign_ad_section
    ad_section_type = params[:ad_code][:ad_section_type]
    if ad_section_type && ad_section_type.in?(AdCode::AD_SECTION_TYPES)
      @ad_section = ad_section_type.constantize.find(params[:ad_code][:ad_section_id])
    end
  end
end
