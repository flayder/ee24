# encoding : utf-8
module Rubricator

  def self.generate_select(site, controller)
    site ||= Site.voronezh

    site_section = site.site_sections.joins(:section).where(:sections => {:controller => controller}).first

    arr = {}

    root_rubrics = site_section.rubric_klass.site(site).roots

    root_rubrics.each do |root_rubric|
      leaves_arr = []
      if root_rubric.leaf?
        leaves_arr << [" - " + root_rubric.title, root_rubric.id]
      else
        leaves = site_section.rubric_klass.site(site).where :id => root_rubric.leaves.map(&:id)
        leaves.each do |leaf|
          leaves_arr << [" - " + leaf.title, leaf.id]
        end
      end
      arr[root_rubric.title] = leaves_arr
    end

    arr
  end

end
