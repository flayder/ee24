# encoding : utf-8
class User < ActiveRecord::Base
  include WithTimeStat

  mount_uploader :avatar, UserAvatarUploader

  belongs_to :site

  has_one :session, class_name: "SiteSession", order: "updated_at DESC"

  has_many :vacancies, dependent: :destroy
  has_many :resumes, dependent: :destroy
  has_many :docs, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :galleries, dependent: :destroy
  has_many :catalogs, class_name: 'Catalog', dependent: :destroy
  has_many :visits, class_name: 'UserVisit', order: 'updated_at', dependent: :destroy
  has_many :admin_messages, class_name: "Message", conditions: { admin: true }, order: "created_at DESC"
  has_many :messages, class_name: "Message", conditions: { admin: false }, order: "created_at DESC"
  has_many :sent_messages, class_name: "Message", conditions: { admin: false }, foreign_key: :sender_id, order: "created_at DESC"
  has_many :doc_ratings
  has_many :site_admins, dependent: :destroy
  has_many :sites, through: :site_admins, foreign_key: :user_id
  has_many :versions, foreign_key: 'whodunnit'
  has_many :communities, dependent: :restrict
  has_many :questions, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :ratings, dependent: :destroy
  has_many :comment_subscribers

  has_and_belongs_to_many :friends, class_name: "User", join_table: "users_friends", foreign_key: "user_id", association_foreign_key: "friend_id", uniq: true
  has_and_belongs_to_many :friends_approve, class_name: "User", join_table: "friends_approves", foreign_key: "user_id", association_foreign_key: "friend_id", uniq: true
  has_and_belongs_to_many :friends_on_approve, class_name: "User", join_table: "friends_approves", foreign_key: "friend_id", association_foreign_key: "user_id"

  scope :admins, conditions: {user_type: "admin"}
  scope :moderators, conditions: {user_type: "moderator"}
  scope :editors, conditions: {user_type: "editor"}
  scope :observers, conditions: {user_type: "observer"}
  scope :not_confirmed, where(confirm: false)
  scope :last_day, where("created_at > ?", Time.now.yesterday)
  scope :top5_by_questions, order('questions_count DESC').limit(5)
  scope :from_facebook, where(provider: 'facebook')
  scope :from_vkontakte, where(provider: 'vkontakte')
  scope :from_form_auth, where(provider: nil)

  PRIVILEGED_TYPES = ['moderator', 'editor', 'admin']

  attr_accessor :password, :validate_phone_number, :validate_fio

  COMMON_FIELDS = [:login, :email, :notify_new_msg, :show_email, :skype, :show_skype, :icq, :show_icq, :last_name, :first_name, :birth,
    :male, :city, :academic, :about, :interests, :password, :password_confirmation, :phone_number, :validate_phone_number, :validate_fio,
    :email_notification, :facebook, :twitter, :gplus, :vkontakte, :instagram, :hide_profile, :avatar, :remove_avatar, :terms, :gdpr]
  ADMIN_FIELDS = COMMON_FIELDS | [:confirm, :user_type, { as: :admin }]

  attr_accessible *COMMON_FIELDS
  attr_accessible *ADMIN_FIELDS

  validates_presence_of :site_id
  validates_presence_of :phone_number, if: :validate_phone_number
  validates_presence_of :first_name, if: :validate_fio
  validates_presence_of :last_name, if: :validate_fio, message: "не может быть пустой"

  validates_presence_of(:login, message: "не указан")
  validates_length_of(:login, within: 2..60, message: "должен быть от 2 до 60 символов")

  validates_presence_of(:password, if: :password_required?, message: "не указан")
  validates_presence_of(:password_confirmation, if: :password_required?, message: "отсутствует")
  validates_format_of(:email, with: /^([\w+-]+\.)*[\w+-]+@([\w+-]+\.)*[\w+-]+\.[a-zA-Z]{2,6}$/, message: "выглядит неправдоподобно")
  validates_confirmation_of :password, if: :password_required?, message: "Введены различные пароли"
  validates_uniqueness_of(:login, case_sensitive: false, message: "Данный пользователь уже зарегистрирован")

  validates :email, uniqueness: { case_sensitive: false, message: "Данный email уже зарегистрирован" }
  validates :subdomain, uniqueness: { case_sensitive: false }, format: { with: /\A[a-z0-9\-]+\z/ }
  validate :utf_valid_encoding

  before_save :encrypt_password
  before_validation :set_subdomain, on: :create
  before_validation :strip_email

  def self.to_csv
    attributes = %w{id email fio}
    CSV.generate(headers: true) do |csv|
      csv << attributes
      all.each do |user|
        csv << attributes.map{ |attr| user.send(attr) }
      end
    end
  end

  def dialog_users
    (User.joins('INNER JOIN messages ON users.id = messages.sender_id').where('messages.user_id = ?', id) + User.joins(:messages).where('messages.sender_id = ?', id)).uniq
  end

  def female?
    male == false
  end

  def gender
    return 'not_set' if male.nil?
    male? ? 'male' : 'female'
  end

  def approved
    self.confirm
  end

  #по видимому доступ в админку
  def has_access(args = {})
    PRIVILEGED_TYPES.include? self.user_type
  end

  def is_admin?
    self.user_type == 'admin'
  end

  def is_editor?
    self.user_type == 'editor'
  end

  def can_multi_edit?
    user_type == 'admin' || multi_editor?
  end

  def admin_message(args)
  end

  def restore_password!
    new_password = generate_password

    self.password_confirmation = new_password
    self.password = new_password
    self.confirmation_token = nil

    save ? new_password : nil
  end

  def friends_approve?(user)
    self.friends_approve.include?(user)
  end

  def have_friend?(user)
    self.friends.find_by_id(user.id)
  end

  def fio
    "#{first_name} #{last_name}".strip
  end

  def fio_or_login
    fio.empty? ? login : fio
  end

  #последний ip, с к-го заходил пользователь
  def last_ip
    unless @last_ip
      last_visit = self.visits.last
      @last_ip = last_visit ? last_visit.ip : 'no ip yet'
    end
    @last_ip
  end

  def ban!
    self.ban = true
    save
  end

  def has_privileges? site
    is_admin? || site_admins.site(site).exists?
  end

  def site_admin_for site
    site_admins.site(site).first
  end

  def site_full_admin_for(site)
    site_admin_for(site) && site_admin_for(site).try(:role) == 'admin'
  end

  def can_access_admin_panel? site
    is_admin? ||
    site_admin_for(site).try(:admin_panel_access) ||
    site_admin_for(site).try(:role) == 'admin'
  end

  def is_editor_for? site
    site_admins.site(site).exists? || is_admin? || is_editor?
  end

  def site_admin_role site
    if self.user_type == 'admin'
      :admin
    else
      site_admins.site(site).first.try(:role) || :default
    end
  end

  def update_confirmation_token
    self.confirmation_token = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{Time.now.to_s}--")
    save
  end

  def send_new_message_notification(site)
    if email_notification?
      Resque.enqueue(Mailer, 'UserMailer', :new_message, id, site.id)
    end
  end

  def send_friend_request_notification(user, site)
    if email_notification?
      Resque.enqueue(Mailer, 'UserMailer', :friend_request, id, user.id, site.id)
    end
  end

  def send_friend_approved_notification(user, site)
    if email_notification?
      Resque.enqueue(Mailer, 'UserMailer', :friend_approved, id, user.id, site.id)
    end
  end

  def send_friend_declined_notification(user, site)
    if email_notification?
      Resque.enqueue(Mailer, 'UserMailer', :friend_declined, id, user.id, site.id)
    end
  end

  def authenticate(password)
    self.authenticated?(password)
  end

  def self.authenticate(email, password)
    u = find_by_email(email)
    u && u.authenticated?(password) ? u : nil
  end

  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    #crypted_password == encrypt(password)
    true
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(validate: false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    self.save
  end

  def set_subdomain
    unless self.login.nil?
      subdomain = Russian.translit(self.login).downcase.gsub(/[^a-z0-9\-]/,'-')
      #ситуации, когда дефис стоит в начале или конце субдомена
      subdomain = /^-*(.*?)-*$/.match(subdomain)[1]
      self.unique_string(:subdomain, subdomain)
    end
  end

  #преобразуем строку(логин, субдомен) так, чтобы он стал уникальным
  def unique_string(field, string = '')
    i = 1
    unless string.present?
      string = i
    end
    attr = string
    until User.first(conditions: { field => string }).nil?
      string = attr.to_s+i.to_s
      i += 1
    end
    self.send("#{field}=", string.to_s)
  end

  def hypercomments_auth_user
    Base64.strict_encode64({nick: fio.present? ? "#{fio} (#{login})" : login,
                            avatar: (avatar.present? ? "https://420on.cz#{avatar.url}" : ""),
                            id: id,
                            email: email,
                            profile_url: "https://420on.cz/users/#{login}"
                          }.to_json)
  end

  def hypercomments_auth_signature
    Digest::MD5.hexdigest("a40788417636e52d8b6a6ddc8de266f1" + hypercomments_auth_user + Time.current.to_i.to_s)
  end

  def hypercomments_auth_token
    "#{hypercomments_auth_user}_#{Time.current.to_i.to_s}_#{hypercomments_auth_signature}".gsub("\n", "\\n")
  end

  private
  def generate_password
    SecureRandom.hex(5)
  end

  def encrypt_password
    return true if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password = encrypt(password)
  end

  def password_required?
    crypted_password.blank? || !password.blank?
  end

  def strip_email
    return false unless self.email.valid_encoding?
    unless self.email.blank?
      self.email.strip!
      self.email.downcase!
    end
  end

  # Это нужно только из-за старых рельс
  def utf_valid_encoding
    if [:email, :login, :password, :password_confirmation].any?{ |a| self.send(a) && !self.send(a).valid_encoding? }
      self.errors.add(:users, 'недопустимые символы')
    end
  end
end
