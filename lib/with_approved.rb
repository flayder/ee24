module WithApproved
  extend ActiveSupport::Concern

  included do
    before_validation :set_approved_at

  	scope :approved, where(:approved => true)
  	scope :not_approved, where(:approved => false)
    scope :editor_generated, where(user_id: Site.where(id: 93).first.try(:site_admins).try(:map, &:user_id))
  	scope :user_generated, joins("LEFT OUTER JOIN users ON users.id = #{self.table_name}.user_id LEFT OUTER JOIN site_admins ON site_admins.user_id = users.id").where(:site_admins => { :id => nil })
  end

  def approved
    self[:approved] ||= false
  end

  def approve!
    self.approved = true
    send_email = self.approved_at_changed?
    self.save!

    if self.user && self.user.email_notification?
      Resque.enqueue(Mailer, 'UserMailer', :approval_notification, self.class.name, self.id)
    end
  end

  def disapprove!
    self.approved = false
    self.approved_at = nil
    self.save!
  end

  private

  def set_approved_at
    if self.respond_to?(:approved_at=) && self.approved?
      self.approved_at ||= Time.now
    end
  end
end
