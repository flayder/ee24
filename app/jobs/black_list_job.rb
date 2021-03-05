class BlackListJob < ResqueJob
  @queue = queue_name

  def self.perform(object_type, object_id)
    object = object_type.constantize.find_by_id(object_id)

    if object
      checker = BlackListChecker.new
      checker.check(object)
    end
  end
end
