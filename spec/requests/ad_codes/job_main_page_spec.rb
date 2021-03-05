# encoding:utf-8
require 'spec_helper'

describe 'Ad codes at Job pages' do
  let!(:site) { create :prague_site }
  let!(:current_user) { create :user }
  let!(:job_section) { create :section, :controller => 'job' }
  let!(:site_section) { create :site_section, :site => site, :section => job_section }
  let!(:vacancy) { create :vacancy, :approved, :site => site }
  let(:banner_type) { 'vertical_right' }
  let!(:site_ad_code) { create :ad_code, site: site, ad_section: site, banner_type: banner_type }
  let!(:job_ad_code) { create :ad_code, site: site, ad_section: site_section, banner_type: banner_type }

  before do
    Rails.cache.clear
    visit job_path
  end

  it 'shows job_ad_code' do
    page.should have_content(job_ad_code.code)
  end
end
