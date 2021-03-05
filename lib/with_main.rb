module WithMain
  def self.included base
    base.class_eval {
      scope :main, where(main: true)
    }
  end
end