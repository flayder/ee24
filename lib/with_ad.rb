module WithAd
  extend ActiveSupport::Concern

  included do
    has_many :ad_codes, as: :ad_section
  end
end
