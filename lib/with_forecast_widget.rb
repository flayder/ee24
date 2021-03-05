module WithForecastWidget
  def self.included(base)
    base.class_eval {
      before_save :destroy_forecast_widget, :if => :'title_changed? && persisted?'
      before_destroy :destroy_forecast_widget
    }

    private
    def find_widget
      url = self.url(self.site)
      url = url.gsub(/\/\d+[-\w]+/, "/#{self.id}-#{self.param_was}") if self.title_changed?

      Forecast::Widget.find_by_url url
    end

    def destroy_forecast_widget
      widget = find_widget
      widget.try(:destroy)
    end
  end
end
