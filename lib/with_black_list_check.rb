module WithBlackListCheck
  def self.included(base)
    base.class_eval do
      after_commit :check_black_list
    end
  end

  private
  def check_black_list
    Resque.enqueue(BlackListJob, self.class.name, id)
  end
end
