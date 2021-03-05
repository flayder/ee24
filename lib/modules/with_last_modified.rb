module Modules
  module WithLastModified
    private
    def set_last_modified obj
      response.headers['Last-Modified'] = obj.updated_at.httpdate
    end
  end
end