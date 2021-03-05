class DocRatingSweeper < ActionController::Caching::Sweeper
  observe DocRating
  
  def after_save doc_rating
    if doc_rating.ratable.respond_to?(:redis_cache_key)
      expire_fragment doc_rating.ratable.redis_cache_key(:show)  
    end
  end
end
