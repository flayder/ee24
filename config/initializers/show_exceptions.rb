# encoding : utf-8
module CustomErrorMiddleware
  module RoutingError
    class Rack
      def initialize(app)
        @app = app
      end

      def call(env)
        response = @app.call(env)
        
        return response if Onru::Application.config.consider_all_requests_local

        case response[0]
        when 403
          ApplicationController.action('render_403').call(env)
        when 404
          ApplicationController.action('render_404').call(env)
        when 500
          ApplicationController.action('render_500').call(env)
        else
          response
        end    

      end
    end
  end
end
