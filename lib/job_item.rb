# encoding : utf-8
module JobItem
  BUSY_STATES = {
    'full' => 'Полный день',
    'free' => 'Свободный график',
    'freelance' => 'Удалённая работа'
  }

  CURRENCY = {
    1 => 'CZK',
    2 => 'EUR',
    3 => 'USD'
  }

  INDEX_ATTRIBUTES = %w(id text title created_at user_id industry_id approved)

  def self.included(base)
    base.class_eval {
      include WithLastUpdatedCache

      belongs_to :industry
      belongs_to :user

      has_many :profession_objects, order: :created_at
      has_many :professions, through: :profession_objects

      has_one :ip, :as => :ip_object, :dependent => :destroy
      has_many :photos, :class_name => 'BoardPhoto', :as => :photoable, :limit => 6, :dependent => :destroy

      accepts_nested_attributes_for :photos, :allow_destroy => true

      validates :industry, :presence => { :message => 'не может быть пустой'}
      validates_presence_of :title
      validates_presence_of :text

      #должны быть указано не больще 3-х специализаций (professions)
      validate :professions_size

      #всё же делаем зарплату псевдоцифровой
      before_save :set_money
      after_save :update_job_items_counts

      scope :industry, lambda { |industry_id| where(industry_id: industry_id) }
      scope :for_profession, lambda { |profession_id| joins(:professions).where('professions.id = ?', profession_id) }
    }
  end

  def reset_approved
    self.approved = false
    self.approved_at = nil
  end

  def busy_title
    busy_title = BUSY_STATES[self.busy]
    busy_title ||= 'Не занятость'
  end

  #хотя странно как-то
  def set_money
    self.money = self.money.to_s.strip.gsub(' ', '').to_i if self.money
  end

  private
  def update_job_items_counts
    industry.update_counters!
    professions.each do |profession|
      profession.update_counters!
    end
  end

  def professions_size
    size = self.professions.size
    unless (1..3).include? size
      errors.add(:professions, "Укажите от 1 до 3-х специализаций")
    end
  end

end
