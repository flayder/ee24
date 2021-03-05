# encoding : utf-8
module Modules
  module Log
    def self.included(base)
      super
      base.send :include, ClassMethods
    end

    module ClassMethods
      #история посещений с айпишниками
      def visit_session_set
        if logged_in?
          user = current_user
          if user
            visit = user.visits.find_or_initialize_by_session(request.session_options[:id])
            visit.updated_at = Time.now
            visit.ip = request.remote_ip
            visit.save
          end
        end
      end

      def user_log
        if logged_in?
          user = current_user
          if user
            user.reload
            user.update_attribute(:visited_at, Time.now)
          end
        end
      end

      def ip_log(object)
        ip = object.build_ip(:ip => request.remote_ip)
        ip.save
      end
    end
  end
end
