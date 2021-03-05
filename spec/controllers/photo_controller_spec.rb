# encoding : utf-8
require 'spec_helper'

describe PhotoController do
  let(:current_user) { create :user }
  let!(:photo_rubric) { create :photo_rubric, :site => @site }
  let!(:second_rubric) { create :photo_rubric, :site => @site }
  let!(:third_rubric) { create :photo_rubric, :site => @site }

  let!(:gallery) { create :gallery, :site => @site, :photo_rubric => photo_rubric, :approved => true }
  let!(:gallery2) { create :gallery, :site => @site, :photo_rubric => photo_rubric, :approved => true }

  let!(:photo_section) { create :photo_section }
  let!(:site_section) { create :site_section, site: @site, section: photo_section }

  before(:each) do
    @request.host = @site.domain
    user_login current_user
  end

  describe 'GET index' do
    before do
      get :rubric, :global_rubric_link => photo_rubric.link
    end

    it 'assigns @galleries' do
      assigns(:galleries).should include(gallery2)
      assigns(:galleries).should include(gallery)
    end
  end

  describe 'GET show' do
    before do
      get :show, :global_rubric_link => photo_rubric.link, :second_rubric_link => second_rubric.link, :gallery_id => gallery.id
    end

    it 'assigns @gallery' do
      assigns(:gallery).should eq(gallery)
    end

    it 'redirect to list' do
      expect(response).to redirect_to("/photo/#{photo_rubric.link}/list/#{gallery.id}")
    end
  end


  describe 'GET list' do
    before do
      get :list,
        :global_rubric_link => photo_rubric.link,
        :gallery_id => gallery2.id
    end

    it 'increments @gallery page_views' do
      $page_views_redis.flushdb

      expect {
        get :list,
          :global_rubric_link => photo_rubric.link,
          :gallery_id => gallery2.id
      }.to change { gallery2.reload.redis_page_views.to_i }.by(2)
    end

    it 'renders list' do
      response.should be_success
    end
  end

  describe 'ad_codes' do
    let!(:site_ad_code) { create :ad_code, :ad_section => @site, :banner_type => 'horizontal_bottom', :site => @site }
    let!(:ad_code) { create :ad_code, :ad_section => site_section, :banner_type => 'horizontal_bottom', :site => @site }
    let!(:rubric_ad_code) { create :ad_code, :ad_section => photo_rubric, :banner_type => 'horizontal_bottom', :site => @site }

    it 'displays proper ad code on index page' do
      get :index
      assigns(:ad_codes)[:horizontal_bottom].should have_content(ad_code.code)
    end

    it 'displays proper ad code on rubric page' do
      get :rubric, :global_rubric_link => photo_rubric.link
      assigns(:ad_codes)[:horizontal_bottom].should have_content(rubric_ad_code.code)
    end

    it 'displays proper ad code on gallery' do
      get :list, :global_rubric_link => photo_rubric.link,:gallery_id => gallery.id
      assigns(:ad_codes)['horizontal_bottom'].should have_content(rubric_ad_code.code)
    end
  end
end
