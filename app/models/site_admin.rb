# encoding : utf-8
class SiteAdmin < ActiveRecord::Base
  include WithSite
  ROLES = %w(admin editor moderator observer)

  belongs_to :user

  has_many :permissions
  has_many :rubric_permissions, :inverse_of => :site_admin
  validates :site, :user, :role, :presence => true
  validates :site_id, :uniqueness => { :scope => :user_id }
  validates :role, :inclusion => { :in => ROLES }

  attr_accessor :section_ids, :user_email

  accepts_nested_attributes_for :user, :site, :limit => 1
  accepts_nested_attributes_for :rubric_permissions, :reject_if => proc { |attributes| attributes[:rubric_id].blank? }

  before_validation :set_user_id
  after_save :set_permissions

  attr_accessible :user_id, :role, :section_ids, :admin_panel_access, :user_email, :rubric_permissions_attributes

  def has_permission? controller
    permissions.joins(:section).where(:sections => { :controller => controller }).exists?
  end

  # RENAME to rubric_ids
  def permitted_rubrics klass
    rubric_permissions.where(:rubric_type => klass.name).pluck(:rubric_id)
  end

  alias_method :old_rubric_permissions_attributes=, :rubric_permissions_attributes=
  def rubric_permissions_attributes= args
    transaction do
      rubric_permissions.where(:rubric_type => args.map { |h| h['rubric_type'] }.uniq).destroy_all
      args.keep_if { |h| h['rubric_id'] }
      send(:old_rubric_permissions_attributes=, args)
    end
  end

  private
  def set_permissions
    unless self.role == 'admin'
      self.section_ids ||= []

      if section_ids.empty?
        self.permissions.destroy_all
      else
        self.permissions.where('section_id NOT IN (?)', section_ids).destroy_all
        section_ids.each do |s_id|
          self.permissions.find_or_create_by_section_id(s_id)
        end
      end
    end
  end

  #в случае, если пользователь не пользовался автокомплитом
  def set_user_id
    if !self.user_id? && self.user_email.present?
      self.user = User.find_by_email(self.user_email)
    end
  end
end
