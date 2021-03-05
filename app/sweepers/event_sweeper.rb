class EventSweeper < ActionController::Caching::Sweeper
  include WithMainPageExpiration
  observe Event
  
  def after_update event
    expire_fragment event.redis_cache_key(:show)
    exprire_main_page event
  end

  def after_destroy event
    exprire_main_page event
  end

  def after_create event
    exprire_main_page event
  end
end
