module WithTimeStat
  def self.included(base)
    base.class_eval do
      scope :of_today, where('created_at > ?', Time.now.beginning_of_day)
      scope :of_the_week, where('created_at > ?', Time.now.beginning_of_day - 1.week)
      scope :of_the_month, where('created_at > ?', Time.now.beginning_of_day - 1.month)
    end
  end
end
