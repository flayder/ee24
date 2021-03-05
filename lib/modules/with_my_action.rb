#encoding: utf-8
module Modules
  module WithMyAction
    private
    def instantiate_my instance_variable, scope, title, action
      instance_variable_set instance_variable, current_user.send(scope).site(@site.id).paginate(page: params[:page], per_page: 20)
      @broads = ["Мои #{title}"]
      @meta_title = "Мои #{title}"
      render :action => action
    end
  end
end