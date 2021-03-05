class DocSweeper < ActionController::Caching::Sweeper
  include WithMainPageExpiration
  observe Doc
  
  def after_update doc
    expire_fragment doc.redis_cache_key(:show)
    exprire_main_page doc
  end

  def after_destroy doc
    exprire_main_page doc
  end

  def after_create doc
    exprire_main_page doc
  end
end