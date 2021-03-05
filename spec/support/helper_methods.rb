def create_site_with_rubric
  let!(:site) { create :site }
  let!(:site_section) { create :site_section, :site => site }
  let!(:global_rubric) { create :global_rubric, :section => site_section.section }
  let!(:rubric) { create :doc_rubric, :global_rubric => global_rubric, :site => site }
end

def setup_rubrics params = {}
  unless section = Section.find_by_controller(params[:controller])
    section = build(:section)
    section.controller = params[:controller] if params[:controller]
    section.save
  end

  unless site_section = SiteSection.where(:site_id => params[:site].id, :section_id => section.id).first
    site_section = create(:site_section, :site => params[:site], :section => section)
  end

  global_rubric = build(:doc_global_rubric, :section => site_section.section)
  global_rubric.link = params[:global_rubric_link] if params[:global_rubric_link]
  global_rubric.save

  rubric = build(:doc_rubric, :global_rubric => global_rubric)
  rubric.link = params[:rubric_link] if params[:rubric_link]
  rubric.save

  site_rubric = create(:site_rubric, :rubric => rubric, :site_section => site_section)
  site_global_rubric = create(:site_rubric, :rubric => global_rubric, :site_section => site_section)

  return global_rubric, rubric, site_rubric, site_global_rubric
end

def create_default_sections(site = nil)
  site ||= create(:site, :domain => '420on.cz')
  ['news', 'afisha', 'catalog', 'job', 'docs'].map do |controller|
    site.sections << create(:section, :controller => controller)
  end
end

def create_default_global_rubrics(site = nil)
  site ||= create(:site, :domain => '420on.cz')
  ['deathfish', 'realty', 'auto', 'shopping'].map do |link|
    create(:global_rubric, :link => link)
  end
end

def with_constants(constants, &block)
  constants.each do |constant, val|
    Object.const_set(constant, val)
  end

  block.call

  constants.each do |constant, val|
    Object.send(:remove_const, constant)
  end
end

def random_password(length = 10)
  ('a'..'z').to_a.shuffle.first(length).join
end

def fixture_file_path(filename)
  File.join(Rails.root, 'spec', '/fixtures/' + filename)
end

def fixture_file(filename)
  File.open fixture_file_path(filename), 'r:utf-8'
end

def fill_in_ckeditor(locator, opts)
  browser = page.driver.browser
  content = opts.fetch(:with).to_json
  page.execute_script <<-SCRIPT
    CKEDITOR.instances['#{locator}'].setData(#{content});
    $('textarea##{locator}').text(#{content});
  SCRIPT
end
