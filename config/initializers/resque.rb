Resque.redis = Redis.new(db: Settings.redis.db.resque, host: ENV['REDIS_HOST'] || 'localhost', port: ENV['REDIS_PORT'] || '6379')

Resque::Pool.after_prefork do
  ActiveRecord::Base.connection.reconnect!
  Resque.redis.client.reconnect
end