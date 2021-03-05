# encoding : utf-8
require 'spec_helper'

describe Admin::SitesController do


  before(:each) do
    @request.host = @site.domain
  end

  describe 'GET show' do
    context 'for user with admin panel access' do
      let!(:site_editor) { create :site_editor, :site => @site, :admin_panel_access => true }

      before do
        login site_editor.user
        get :show
      end

      it 'renders site page' do
        response.should be_success
      end
    end

    context 'for user without admin panel access' do
      let!(:site_editor) { create :site_editor, :site => @site }

      before do
        login site_editor.user
      end

      it 'redirects to root_url' do
        #expect {
        get :show
        expect(response).to redirect_to(root_url)
        #}.to raise_error(CanCan::AccessDenied)
      end
    end
  end
end
