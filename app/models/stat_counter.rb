class StatCounter < ActiveRecord::Base
  include WithSite

  SECTION_MODELS = {
    :job => [Vacancy, Resume],
    :catalog => [Catalog],
    :afisha => [Event],
    :docs => [Doc],
    :dictionary_objects => [DictionaryObject],
  }

  attr_accessible :date, :model, :count, :site_id

  validates :count, :date, :model, :site_id, presence: true
  validates_uniqueness_of :model, scope: [:date, :site_id]
  validates :model, :inclusion => { :in => SECTION_MODELS.values.flatten.map(&:name) }

  scope :for_display, where('date >= ?', 20.days.ago).order('date ASC')

  def self.generate date
    Site.active.find_each do |site|
      StatCounter::SECTION_MODELS.each_pair do |section, klasses|
        if site.has_section?(section)
          klasses.each do |klass|
            query = klass.respond_to?('site') ? klass.site(site) : klass
            query = query.where('DATE(created_at) < DATE(?)', date)
            query = query.approved if klass.instance_methods.include?(:approved)
            count = query.count

            site.stat_counters.create!(
              :date => date,
              :model => klass.name,
              :count => count
            )
          end
        end
      end
    end
  end
end
