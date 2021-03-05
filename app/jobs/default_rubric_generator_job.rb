# encoding : utf-8
class DefaultRubricGeneratorJob < ResqueJob
  @queue = queue_name

  def self.perform site_id
    site = Site.find site_id
    site.assign_default_rubrics!
  end
end
