# encoding:utf-8
require 'spec_helper'

describe 'Main menu links' do
  let!(:site) { create :prague_site }

  before(:each) do
    Rails.cache.clear
  end

  context 'with css class specified' do
    let!(:link) { create :main_menu_link, :highlighted, site: site }

    before(:each) do
      visit root_path
    end

    it 'has css class' do
      page.should have_css('div.main-links a', count: 1)
      page.should have_css("a.#{link.css_class}")
    end

    it 'shows link and title' do
      page.should have_link link.title, link.path
    end
  end

  context 'with positions' do
    let!(:link_1) { create :main_menu_link, site: site, position: 0 }
    let!(:link_2) { create :main_menu_link, site: site, position: 1 }
    let!(:link_3) { create :main_menu_link, site: site, position: nil }

    before(:each) do
      visit root_path
    end

    it 'shows ordered by position' do
      page.should have_content(/#{link_1.title}.*#{link_2.title}.*#{link_3.title}/)
    end

    it 'shows link and title' do
      page.should have_css('div.main-links a', count: 3)
      page.should have_link link_1.title, link_1.path
      page.should have_link link_2.title, link_2.path
      page.should have_link link_3.title, link_3.path
    end
  end
end
