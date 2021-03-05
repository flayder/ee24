class Question < ActiveRecord::Base
  include WithApproved
  acts_as_paranoid

  attr_accessible :title, :category_id, :language, :category, :content, :answer, :user_id, :approved

  has_many :comments, as: :commentable, dependent: :destroy
  has_many :comment_subscribers, as: :subscriberable

  belongs_to :category
  belongs_to :user, counter_cache: true


  validates :title, :category_id, :content, :user_id, presence: true

  scope :popular, lambda { joins(:comments).group('questions.id').order('count(comments.id) desc') }
  scope :by_language, lambda { where(language: I18n.locale.to_s) }

  def url
    ['', 'categories', category.id, 'questions', self.id].join('/')
  end

  def content
    read_attribute(:content).gsub(/<!--(.|\s)*?-->/, '')
  end

  def pure_content
    read_attribute(:content)
  end

end
