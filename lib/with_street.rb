# encoding : utf-8
module WithStreet
  def self.included(base)
    base.class_eval {
      belongs_to :street

      before_validation :set_street

      validates :street, :presence => true

      #before_save :set_coordinates

      attr_writer :street_title

      delegate :site, :to => :city
    }
  end

  def gmaps4rails_address
    addr = self.city ? "#{self.city.title}, " : ''
    addr += self.full_address
  end

  def full_address
    [self.street_title, self.address].select{|a|a.present?}.join(', ')
  end

  def coordinates
    [self.lat, self.lng]
  end

  def street_title
    if @street_title.present?
      @street_title
    else
      self.street.present? ? self.street.title : ''
    end
  end

  def set_street
    if self.street_title.present? && self.city.present?
      street = self.city.streets.find_or_create_by_title(self.street_title)
      self.street = street
    end
  end

end
