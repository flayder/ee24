require 'differ'

Differ.format = :html

class Admin::VersionsController < Admin::BaseController
  authorize_resource :version

  #список разделов, для которых сохраняем изменения
  def index
    @search = Version.joins(:author).site(@site).metasearch(params[:search])
    @versions = @search.page(params[:page]) if params[:search].present?
  end

  #список изменений объекта
  def month
    @year = params[:year].present? ? params[:year].to_i : Date.today.year
    @month = params[:month].present? ? params[:month].to_i : Date.today.month
    @date = Date.new(@year, @month, 1)
    @versions = {}
    1.upto(Time.days_in_month(@month, @year)) do |day|
      versions = @site.versions.where(item_type: params[:item_type]).where('date(created_at) between ? and ?', Time.new(@year, @month, day), Time.new(@year, @month, day)+1.day)
      if versions.present?
        @versions[day] = {}
        %w(update create destroy).each do |event|
          @versions[day][event] = versions.select{|v| v.event == event }
        end
      end
    end
  end

  #история изменений объекта
  def show
    @item = object_klass.site(@site.id).find(params[:item_id])
  end

  def diff
    @version = @site.versions.find(params[:id])
  end

  private
  def object_klass
    if params[:item_type].in?(Version::OBJECTS)
      params[:item_type].constantize
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end
