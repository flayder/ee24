# encoding : utf-8
require 'spec_helper'

describe Admin::UsersController do

  let!(:site_editor) { create :site_editor, :site => @site, :admin_panel_access => true }
  let!(:user) { create :user }

  before(:each) do
    @request.host = @site.domain
    @request.env['HTTP_REFERER'] = "http://#{@site.domain}"
    login site_editor.user
  end

  describe 'PUT toggle_ban' do
    before :each do
      put :toggle_ban, :id => user.id
    end

    it 'change ban user attribute' do
      user.reload.ban?.should be_truthy
    end

    it 'should redirect back' do
      response.should be_redirect
    end
  end
end
