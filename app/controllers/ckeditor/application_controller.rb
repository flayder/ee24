class Ckeditor::ApplicationController < ApplicationController
  layout 'ckeditor/application'

  before_filter :find_asset, :only => [:destroy]
  before_filter :ckeditor_authorize!
  before_filter :authorize_resource

  protected

  def respond_with_asset(asset)
    file = params[:CKEditor].blank? ? params[:qqfile] : params[:upload]
    asset.data = Ckeditor::Http.normalize_param(file, request)

    callback = ckeditor_before_create_asset(asset)
    if callback && asset.save
      if params[:CKEditor].blank?
        render :json => asset.to_json(:only=>[:id, :type])
      else
        render :text => %Q"<script type='text/javascript'>
              window.parent.CKEDITOR.tools.callFunction(#{params[:CKEditorFuncNum]}, '#{config.relative_url_root}#{Ckeditor::Utils.escape_single_quotes(asset.url_content)}');
            </script>"
      end
    else
      if params[:CKEditor].blank?
        if asset.valid?
          render :nothing => true, :format => :json
        else
          # Hide failed upload block and show alert to user
          render :text => "$('#asset_0').hide() + alert('#{Ckeditor::Utils.escape_single_quotes(asset.errors.full_messages.first)}')"
        end
      else
        render :text => %Q"<script type='text/javascript'>
              window.parent.CKEDITOR.tools.callFunction(#{params[:CKEditorFuncNum]}, null, '#{Ckeditor::Utils.escape_single_quotes(asset.errors.full_messages.first)}');
            </script>"
      end
    end
  end
end
