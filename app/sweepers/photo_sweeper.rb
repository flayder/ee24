class PhotoSweeper < ActionController::Caching::Sweeper
  include WithMainPageExpiration
  observe Photo

  def after_update photo
    exprire_main_page photo
  end

  def after_destroy photo
    exprire_main_page photo
  end

  def after_create photo
    exprire_main_page photo
  end
end
