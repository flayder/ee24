module Admin::SitesHelper
  def load_time_counters site
    points = []

    klasses = []
    StatCounter::SECTION_MODELS.each do |section, section_klasses|
      klasses += section_klasses if site.has_section?(section)
    end

    (0..11).map { |i| Date.today - i.months }.reverse.each do |date|
      points << [Russian::strftime(date, "%B, %y")] +
        klasses.map { |klass| StatCounter.site(site).where('YEAR(date) = ? AND MONTH(date) = ?', date.year, date.month).where(model: klass.name).order('created_at DESC').first.try(:count) }
    end

    points.insert(0, klasses.map { |k| k.model_name.human }.insert(0, 'Date'))

    points.to_json.html_safe
  end
end
