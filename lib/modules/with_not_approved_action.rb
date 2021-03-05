module Modules
  module WithNotApprovedAction
    def set_not_approved klass, collection_name, site, params
      authorize! :manage, klass
      collection = klass.site(site.id).not_approved.order('created_at DESC')
      collection = params[:editor] ? collection.editor_generated : collection.user_generated
      collection = collection.uniq.paginate(page: params[:page], per_page: 20)

      instance_variable_set collection_name, collection
    end
  end
end