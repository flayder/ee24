class MainBlockSweeper < ActionController::Caching::Sweeper
  include WithMainPageExpiration
  observe MainBlock
  
  def after_update main_block
    exprire_main_page main_block
  end

  def after_destroy main_block
    exprire_main_page main_block
  end

  def after_create main_block
    exprire_main_page main_block
  end
end
