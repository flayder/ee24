class PageViewsUpdater
  def self.update_async
    Resque.enqueue PageViewsJob, *$page_views_redis.keys
  end

  def self.update keys
    keys.each do |key|
      klass, id = key.split(':')

      obj = klass.constantize.find_by_id(id)
      page_views = $page_views_redis.get(key).to_i

      # NOTICE
      # we update page_views only if new value is more than current.
      # The thing is that if resque worker stopped and there are a lot of page_views
      # tasks in queue they can easily pollute page_views data.
      obj.update_column :page_views, page_views if obj.try(:page_views) && obj.page_views < page_views

      $page_views_redis.del key
    end
  end
end
