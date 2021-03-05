# encoding : utf-8
class Admin::MetrikaApiAccountsController < Admin::BaseController
  authorize_resource :metrika_api_account

  def show
    @metrika_api_account = @site.metrika_api_account
  end
  alias :edit :show

  def url_phrases
    @url = @site.metrika_api_account.urls.find_by_body params[:url]
  end

  def update
    if @site.metrika_api_account.update_attributes(params[:metrika_api_account])
      redirect_to :action => :show, :notice => 'Акканут Яндекс.Метрики успешно обновлен'
    else
      render :action => :edit
    end
  end
end
