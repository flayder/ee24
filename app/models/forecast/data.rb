class Forecast::Data < ActiveRecord::Base
  attr_accessible :icon, :location_id, :pressure, :temperature, :timestamp, :wind_speed

  belongs_to :location

  AVAILABLE_DAYS = %w(5 7 10 14).map { |d| "#{d}dney"}

  # TODO SNAP There is no pressure in daily forecast
  validates :icon, :location_id , :timestamp, :wind_speed, presence: true
  validates :location_id, uniqueness: { scope: :timestamp }

  scope :current, where('temperature IS NOT NULL')
  scope :today, lambda { where('DATE(timestamp) = ?', Date.today) }
  scope :timestamp_gt, lambda { |time| where('timestamp >= ?', time) }

  def message
    data_message = Forecast::DataMessage.new
    data_message.message(icon)
  end
end
