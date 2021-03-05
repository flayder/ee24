class Forecast::Widget < ActiveRecord::Base
  attr_accessible :location_id, :url, :anchor_id

  belongs_to :location
  belongs_to :anchor

  before_destroy :inc_anchor_limit

  validates :location_id, :url, :anchor_id, presence: true
  # TODO validates uniq of url

  private
  def inc_anchor_limit
    anchor.increment!(:limit)
  end
end
