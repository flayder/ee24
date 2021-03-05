module Cacheable
  # REFACTOR rename to cache_key after
  # some investigation :)
  def redis_cache_key type
    "#{self.class.name}:#{id}:#{type}"
  end
end
