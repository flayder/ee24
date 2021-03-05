# encoding : utf-8
require 'spec_helper'

describe AfishaController do
  let!(:event_rubric) { create :event_rubric, :site => @site }
  let(:event) { create :event, :approved, :rubric => event_rubric, :site => @site, :param => nil }
  let!(:unevent) { create :event, :site => @site, :rubric => event_rubric }
  let!(:afisha_section) { create :section, :controller => 'afisha' }
  let!(:site_section) { create :site_section, site: @site, section: afisha_section }
  let!(:user) {create :user}

  before(:each) do
    @request.host = @site.domain
  end

  describe 'GET show' do
    context 'for owner' do
      let!(:event) { create :event, :site => @site, :rubric => event_rubric, :user => user }

      before do
        user_login user
      end

      it 'should render success  for unapproved event owner' do
        get :show_event, :rubric => event_rubric.link, :id => "#{event.id}-#{event.param}"
        response.should be_success
      end
    end

    context 'not for owner' do
      it 'should show event' do
        get :show_event, :rubric => event_rubric.link, :id => "#{event.id}-#{event.param}"
        response.should be_success
      end

      it 'should render 404 for unapproved event' do
        #expect {
        get :show_event, :rubric => event_rubric.link, :id => "#{unevent.id}-#{unevent.param}"
        #}.to raise_error(CanCan::AccessDenied)
        expect(response).to redirect_to(root_url)
      end
    end

    it 'increases page_views' do
      $page_views_redis.flushdb
      expect {
        get :show_event, :rubric => event_rubric.link, :id => "#{event.id}-#{event.param}"
      }.to change { event.reload.redis_page_views.to_i }.by(2)
    end
  end

  describe 'ad_codes' do
    let!(:site_ad_code) { create :ad_code, :ad_section => @site, :banner_type => 'horizontal_top', :site => @site }
    let!(:ad_code) { create :ad_code, :ad_section => site_section, :banner_type => 'horizontal_top', :site => @site }
    let!(:rubric_ad_code) { create :ad_code, :ad_section => event_rubric, :banner_type => 'horizontal_top', :site => @site }
    let!(:event_ad_code) { create :ad_code, :url => event.url, :banner_type => 'horizontal_top', :site => @site }

    it 'should display right ad code for section' do
      get :index
      assigns(:ad_codes)[:horizontal_top].should have_content(ad_code.code)
    end

    it 'should display right ad code for rubric' do
      get :rubric, :id => event_rubric.link
      assigns(:ad_codes)[:horizontal_top].should have_content(rubric_ad_code.code)
    end

    it 'should display right ad code for event' do
      get :show_event, :rubric => event_rubric.link, :id => "#{event.id}-#{event.param}"
      assigns(:ad_codes)[:horizontal_top].should have_content(event_ad_code.code)
    end

  end

  describe 'DELETE destroy' do
    let!(:event) { create :event, :approved, :site => @site }
    before { admin_login }

    context 'with referer' do
      before do
        @request.env["HTTP_REFERER"] = "/"
      end

      it 'redirects to referer' do
        delete :destroy, :id => event.id
        expect(response).to redirect_to('/')
      end

      it 'destroys the event' do
        lambda {
          delete :destroy, :id => event.id
        }.should change(Event, :count).by(-1)
      end
    end

    context 'without referer' do
      it 'redirects to index page if no referer' do
        delete :destroy, :id => event.id
        expect(response).to redirect_to('/afisha')
      end
    end
  end
end
