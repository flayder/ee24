module Modules
  module WithRedirect
    private
    def check_redirect
      redirect = @site.redirects.where(from: request.url).first

      if redirect
        redirect_to(redirect.to, status: :moved_permanently)
      end
    end
  end
end
