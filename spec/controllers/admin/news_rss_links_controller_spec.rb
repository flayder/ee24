# encoding : utf-8
require 'spec_helper'

describe Admin::NewsRssLinksController do

  let!(:admin) { create :site_admin, :site => @site }

  before(:each) do
    @request.host = @site.domain
  end

  describe 'GET index' do
    context 'when authorized user' do
      before do
        login admin.user
        get :index
      end

      it 'should response with 200' do
        response.status.should eq(200)
      end
    end

    context 'when unauthorized user' do
      it 'should response with 404' do
       #expect {
          get :index
       # }.to raise_error(CanCan::AccessDenied)
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
