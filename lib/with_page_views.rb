module WithPageViews
  def page_views_redis_key
    "#{self.class.name}:#{id}"
  end

  def redis_page_views
    $page_views_redis.get page_views_redis_key
  end

  def delete_page_views_redis_key
    $page_views_redis.del page_views_redis_key
  end

  def inc_page_views! site
    $page_views_redis.setnx page_views_redis_key, page_views
    $page_views_redis.incrby page_views_redis_key, site.voronezh? ? rand(5) + 1 : 1
  end
end