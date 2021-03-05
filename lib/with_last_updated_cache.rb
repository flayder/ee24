# encoding : utf-8
module WithLastUpdatedCache
  def self.included(base)
    base.class_eval {
      after_touch :update_last_updated_cache
      after_save :update_last_updated_cache
      after_destroy :touch_after_destroy

      def self.last_updated_cache_key
        generate_last_updated_cache if Rails.cache.read(self.to_s + "_last_updated_cache_key").blank?

        return Rails.cache.read(self.to_s + "_last_updated_cache_key")
      end

      def self.last_updated_at
        generate_last_updated_cache if Rails.cache.read(self.to_s + "_last_updated_at").blank?

        return Rails.cache.read(self.to_s + "_last_updated_at")
      end

      private

      def self.generate_last_updated_cache      
        if last_object = self.order("updated_at DESC").limit(1).first
          Rails.cache.write self.to_s + "_last_updated_at", last_object.updated_at
          Rails.cache.write self.to_s + "_last_updated_cache_key", last_object.cache_key
        end
      end
    }
  end

  def touch_after_destroy
    last_object = self.class.order("updated_at DESC").limit(1).first
    last_object.touch if last_object
  end

  def update_last_updated_cache
    Rails.cache.write self.class.to_s + "_last_updated_cache_key", cache_key
    Rails.cache.write self.class.to_s + "_last_updated_at", updated_at
  end
end
