class Mailer < ResqueJob
  @queue = queue_name
  
  def self.perform klass, action, *params
    klass.classify.constantize.send(action, *params).deliver
  end
end