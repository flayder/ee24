class PageViewsJob < ResqueJob
  @queue = queue_name
  
  def self.perform *keys
    PageViewsUpdater.update keys
  end
end