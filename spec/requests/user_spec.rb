# encoding:utf-8
require 'spec_helper'

describe 'User' do
  let!(:site) { create :prague_site }
  let!(:current_user) { create :user, site: site }

  before do
    Rails.cache.clear
    login current_user
  end

  context 'Gallery' do
    let!(:photo_section) { create :section, :controller => 'photo' }
    let!(:site_section) { create :site_section, :site => site, :section => photo_section }
    let!(:photo_rubric) { create :photo_rubric, :site => site }
    let!(:gallery) { create :gallery, :site => site, :rubric => photo_rubric, :user => current_user }

    let!(:another_photo_rubric) { create :photo_rubric, :site => site }
    let!(:another_gallery) { create :gallery, :site => site, :rubric => photo_rubric }
    let!(:another_rubric_gallery) { create :gallery, :site => site, :rubric => another_photo_rubric }

    context 'on my page' do
      before { visit my_galleries_path }

      it 'sees articles' do
        page.should have_css('div.gallery.b-items-list__item', :count => 1)
      end

      it 'sees edit link' do
        find('div.gallery.b-items-list__item').should have_link('Редактировать')
      end
    end
  end
end
