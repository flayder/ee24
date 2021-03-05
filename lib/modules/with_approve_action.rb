module Modules
  module WithApproveAction
    def approve! klass, id, site
      doc = klass.site(site).find id
      authorize! :approve, doc

      doc.approve!
      redirect_to action: :not_approved
    end
  end
end