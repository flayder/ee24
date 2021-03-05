# encoding : utf-8
class Profession < ActiveRecord::Base
  belongs_to :industry

  validates :title, presence: true
  has_many :profession_objects, dependent: :destroy
  has_many :vacancies, through: :profession_objects
  has_many :resumes, through: :profession_objects

  attr_accessible :title, :industry_id, :main, as: :admin

  def path job_type
    "/job/#{job_type.pluralize}/profession/#{id}"
  end

  def update_counters!
    self.resumes_count = resumes.approved.count
    self.vacancy_count = vacancies.approved.count
    self.job_items_count = vacancy_count + resumes_count
    save
  end
end
