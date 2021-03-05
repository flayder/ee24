# encoding: utf-8
require 'spec_helper'

describe CatalogController do

  let(:current_user) { create :user }
  let!(:catalog_rubric) { create :catalog_rubric, :site => @site }
  let!(:child_catalog_rubric) { create :catalog_rubric, :parent => catalog_rubric, :site => @site }
  let!(:catalog) { create :catalog, :approved, :site => @site, :rubric => child_catalog_rubric }
  let!(:catalog_attributes) { create(:catalog, :site => @site).attributes.merge(rubric_ids: create(:catalog_rubric, site: @site).id, catalog_descriptions_attributes: {'0' => build(:catalog_description, catalog: nil).attributes}) }
  let!(:catalog_section) { create :section, :controller => 'catalog' }
  let!(:site_section) { create :site_section, :site => @site, :section => catalog_section }

  before(:each) do
    @request.host = @site.domain
    user_login current_user
  end

  describe 'ad_codes' do
    let(:site_ad_code) { create :ad_code, :ad_section => @site, :banner_type => 'horizontal_top', :site => @site }
    let(:ad_code) { create :ad_code, :ad_section => site_section, :banner_type => 'horizontal_top', :site => @site }
    let(:rubric_ad_code) { create :ad_code, :ad_section => catalog_rubric, :banner_type => 'horizontal_top', :site => @site }
    let(:child_rubric_ad_code) { create :ad_code, :ad_section => child_catalog_rubric, :banner_type => 'horizontal_top', :site => @site }

    before(:each) do
      site_ad_code
      ad_code
      rubric_ad_code
    end

    it 'should display right ad code on rubric page' do
      get :list, :id => catalog_rubric.id
      assigns(:ad_codes)[:horizontal_top].should have_content(rubric_ad_code.code)
    end

    it 'should display right ad code on rubric page with parent' do
      child_rubric_ad_code
      get :list, :id => child_catalog_rubric.id
      assigns(:ad_codes)[:horizontal_top].should have_content(child_rubric_ad_code.code)
    end

    it 'should display right ad code on company page' do
      child_rubric_ad_code
      get :show, :rubric_id => child_catalog_rubric.id, :id => catalog.id
      assigns(:ad_codes)[:horizontal_top].should have_content(child_rubric_ad_code.code)
    end

  end

  it "should render index" do
    get :index
    response.should be_success
    response.should render_template("catalog/index")
  end

  it "should create catalog" do
    lambda do
      post :create, :catalog => catalog_attributes
    end.should change(Catalog, :count).by(1)
  end


  it "should create catalog with user" do
    post :create, :catalog => catalog_attributes
    assigns(:catalog).user.should == current_user
  end

  it "should create not approved catalog" do
    post :create, :catalog => catalog_attributes
    assigns(:catalog).approved.should == false
  end

  it "should create not approved catalog" do
    attrs = catalog_attributes
    attrs['approved'] = true
    post :create, :catalog => attrs
    assigns(:catalog).approved.should == false
  end

  it "should create not approved catalog for just editor" do
    @site.site_admins.create(:user_id => current_user.id, :role => 'editor')
    attrs = catalog_attributes
    attrs['approved'] = true
    post :create, :catalog => attrs
    assigns(:catalog).approved.should == false
  end

  it "should create approved catalog for admin" do
    attrs = catalog_attributes
    attrs['approved'] = true
    @site.site_admins.create(:user_id => current_user.id, :role => 'admin')
    post :create, :catalog => attrs
    assigns(:catalog).approved.should == true
  end

  it "should create catalog without meta for user" do
    attrs = catalog_attributes
    attrs['meta_title'] = 'weird title'
    post :create, :catalog => attrs
    assigns(:catalog).attributes[:meta_title].should be_nil
  end

  it "should create catalog with meta for admin" do
    attrs = catalog_attributes
    attrs['meta_title'] = 'weird title'
    @site.site_admins.create(:user_id => current_user.id, :role => 'admin')
    post :create, :catalog => attrs
    assigns(:catalog).attributes['meta_title'].should == 'weird title'
  end

  it "should create catalog without meta for just editor" do
    @site.site_admins.create(:user_id => current_user.id, :role => 'editor')
    attrs = catalog_attributes
    attrs['meta_title'] = 'weird title'
    post :create, :catalog => attrs
    assigns(:catalog).attributes['meta_title'].should be_nil
  end

  it "should not edit news for user" do
    #expect {
    post :edit, :id => catalog.id
    expect(response).to redirect_to(root_url)
    #}.to raise_error(CanCan::AccessDenied)
  end

  it "should not destroy news for user" do
    #expect {
    delete :destroy, :id => catalog.id
    expect(response).to redirect_to(root_url)
    #}.to raise_error(CanCan::AccessDenied)
  end

  describe 'editor stuff' do
    let!(:catalog) { create :catalog, :site => @site }
    let!(:site_admin) { @site.site_admins.create(:user_id => current_user.id, :role => 'editor') }

    before :each do
      site_admin.permissions.create(:section_id => catalog_section.id)
    end

    it "should create approved news for editor" do
      attrs = catalog_attributes
      attrs['approved'] = true
      post :create, :catalog => attrs
      assigns(:catalog).approved.should == true
    end

    it "should create news with meta title for editor" do
      attrs = catalog_attributes
      attrs['meta_title'] = 'weird title'
      post :create, :catalog => attrs
      assigns(:catalog).attributes['meta_title'].should == 'weird title'
    end

    it "should destroy catalog for admin" do
      lambda do
        delete :destroy, :id => catalog.id
      end.should change(Catalog, :count).by(-1)
    end

  end

  describe 'GET show not approved catalog' do
    context 'for owner' do
      let!(:catalog) { create :catalog, :site => @site, :rubric => child_catalog_rubric }

      it 'should render 404 for unapproved catalog owner' do
        get :show, :id => catalog.id, :rubric_id => catalog.rubrics.first.id
        expect(response).to redirect_to(root_url)
      end
    end

    context 'not for owner' do
      let!(:catalog) { create :catalog, :site => @site, :rubric => child_catalog_rubric, :user => current_user }

      before { get :show, :id => catalog.id, :rubric_id => catalog.rubrics.first.id }

      it 'renders for unapproved catalog' do
        response.should be_success
      end
    end
  end

  describe 'GET show catalog' do
    let!(:catalog) { create :catalog, :approved, :site => @site, :rubric => child_catalog_rubric }

    before :each do
      get :show, :id => catalog.id, :rubric_id => catalog.rubrics.first.id
    end

    it 'should be success' do
      response.should be_success
    end

    it 'should assign @catalog' do
      assigns(:place).should eq(catalog)
    end

    it 'should assign @rubric' do
      pending 'Fix it'
      get :show, :id => catalog.id, :rubric_id => catalog.rubrics.first.id
      assigns(:rubric).should eq(catalog.rubric)
    end

    it 'should render show template' do
      get :show, :id => catalog.id, :rubric_id => catalog.rubrics.first.id
      response.should be_success
      response.should render_template('show')
    end

    it 'increases page_views' do
      $page_views_redis.flushdb
      expect {
        get :show, :id => catalog.id, :rubric_id => catalog.rubrics.first.id
      }.to change { catalog.reload.redis_page_views.to_i }.by(2)
    end
  end
end
