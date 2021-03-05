class ResqueJob
  class << self
    private
    def queue_name
      :"#{Rails.application.class.parent_name.downcase}_#{Rails.env}_#{self.name.underscore}"
    end
  end  
end