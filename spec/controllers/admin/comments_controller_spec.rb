require 'spec_helper'

describe Admin::CommentsController do
  let!(:admin) { create :site_admin, site: @site }

  before(:each) do
    login admin.user
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end

    it "should render the correct template" do
      get "index"
      response.should render_template(:index)
    end
  end

end
