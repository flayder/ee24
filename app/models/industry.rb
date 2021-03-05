class Industry < ActiveRecord::Base
  include SeoValues

  validates :title, presence: true
  has_many :professions, dependent: :destroy
  has_many :vacancies, dependent: :destroy
  has_many :resumes, dependent: :destroy

  attr_accessible :title, :main, as: :admin

  def path(job_type)
    "/job/#{job_type.pluralize}/industry/#{id}"
  end

  def update_counters!
    self.job_items_count = vacancies.approved.count + resumes.approved.count
    save
  end
end
