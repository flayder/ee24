module WithLink
  def self.included base
    base.class_eval do
      scope :link, lambda { |link| where(link: link) }
    end
  end
end