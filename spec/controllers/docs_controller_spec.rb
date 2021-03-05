# encoding: utf-8
require 'spec_helper'

describe DocsController do

  let!(:current_user) { create :user }
  let!(:docs_section) { create :section, :controller => 'docs' }
  let!(:site_section) { create :site_section, :site => @site, :section => docs_section }
  let!(:global_rubric) { create :doc_global_rubric, :site => @site }
  let!(:doc_rubric) { create :doc_rubric, :global_rubric => global_rubric, :site => @site }
  let!(:doc) { create :doc, :rubric => doc_rubric, :site => @site }

  before(:each) do
    @request.host = @site.domain
    user_login current_user
  end

  describe 'GET index' do
    it "should render index" do
      get :index, :global_rubric => global_rubric.link
      response.should be_success
      response.should render_template("docs/index")
    end

    it 'removes page=1 from params and redirects back' do
      get :index, :global_rubric => global_rubric.link, :page => 1
      response.should redirect_to("/#{global_rubric.url}")
    end
  end

  describe 'POST create' do
    let(:attrs) { doc.attributes }
    let!(:doc) { build :doc, rubric: doc_rubric, site: @site, user: current_user }

    it "should create docs" do
      lambda do
        post :create, :doc => doc.attributes, :global_rubric => global_rubric.link
      end.should change(Doc, :count).by(1)
    end

    it "should create docs with user" do
      post :create, :doc => doc.attributes, :global_rubric => global_rubric.link
      assigns(:doc).user.should == current_user
    end

    it "should create not approved docs" do
      post :create, :doc => doc.attributes, :global_rubric => global_rubric.link
      assigns(:doc).approved.should == false
    end

    it "should create not approved docs" do
      attrs['approved'] = true
      post :create, :doc => attrs, :global_rubric => global_rubric.link
      assigns(:doc).approved.should == false
    end

    it "create unapproved docs for just editor" do
      @site.site_admins.create(:user_id => current_user.id, :role => 'editor')
      attrs['approved'] = true
      post :create, :doc => attrs, :global_rubric => global_rubric.link
      assigns(:doc).approved.should == false
    end

    it "create approved docs for admin" do
      attrs['approved'] = true
      @site.site_admins.create(:user_id => current_user.id, :role => 'admin')
      post :create, :doc => attrs, :global_rubric => global_rubric.link
      assigns(:doc).approved.should == true
    end
  end

  describe 'GET edit' do
    it "should not edit docs for user" do
      #expect {
      get :edit, :id => doc.id, :global_rubric => global_rubric.link
      expect(response).to redirect_to(root_url)      
      #}.to raise_error(CanCan::AccessDenied)
    end
  end

  describe 'DELETE destroy' do
    it "not destroy docs for user" do
      #expect {
      delete :destroy, :id => doc.id, :global_rubric => global_rubric.link
      expect(response).to redirect_to(root_url)
      #}.to raise_error(CanCan::AccessDenied)
    end
  end

  describe 'editor stuff' do
    before :each do
      sa = @site.site_admins.create(:user_id => current_user.id, :role => 'editor')
      sa.permissions.create(:section_id => docs_section.id)
    end

    describe 'POST create' do
      let(:attrs) { doc.attributes }

      it "should create approved docs for editor" do
        attrs['approved'] = true
        post :create, :doc => attrs, :global_rubric => global_rubric.link
        assigns(:doc).approved.should == true
      end
    end

    it "should destroy docs for admin" do
      doc = create(:doc, :site_id => @site.id, :rubric => doc_rubric)
      lambda do
        delete :destroy, :id => doc.id, :global_rubric => global_rubric.link
      end.should change(Doc, :count).by(-1)
    end
  end

  describe 'GET show not approved doc' do
    let(:unapproved_doc) { create(:doc, :rubric => doc_rubric, :site => @site, :approved => false) }

    context 'for doc owner' do
      let(:unapproved_doc) { create(:doc, :rubric => doc_rubric, :site => @site, :approved => false, :user => current_user) }

      it 'renders unapproved doc for ownner' do
        get :show, :id => "#{unapproved_doc.id}-#{unapproved_doc.param}", :global_rubric => unapproved_doc.global_rubric.link, :rubric => unapproved_doc.rubric.link
        response.should be_success
      end
    end

    context 'not for doc owner' do
      it 'renders 404 for unapproved doc' do
        #expect {
        get :show, :id => "#{unapproved_doc.id}-#{unapproved_doc.param}", :global_rubric => unapproved_doc.global_rubric.link, :rubric => unapproved_doc.rubric.link
        expect(response).to redirect_to(root_url)
        #}.to raise_error(CanCan::AccessDenied)
      end
    end
  end

  describe 'GET show' do
    let(:doc) { create(:doc, :approved, :rubric => doc_rubric, :site => @site) }

    before do
      get :show, :id => "#{doc.id}-#{doc.param}", :global_rubric => doc.global_rubric.link, :rubric => doc.rubric.link
    end

    it 'assigns doc' do
      assigns(:doc).should eq(doc)
    end

    it 'assigns @rubric' do
      assigns(:rubric).should eq(doc.rubric)
    end

    it 'renders show template' do
      response.should be_success
      response.should render_template('show')
    end
  end

  describe 'PUT approve' do
    let!(:site_editor) { create :site_editor, :site => @site }
    let!(:permission) { create :permission, :section => docs_section }
    let(:doc) { create(:doc, :rubric => doc_rubric, :site => @site) }

    before { user_login site_editor.user }

    it 'should approve doc' do
      lambda {
        put :approve, :id => doc.id, :global_rubric => doc.global_rubric.link, :rubric => doc.rubric.link
      }.should change { doc.reload.approved }.from(false).to(true)
      doc.reload.approved_at.should_not be_nil
    end

    context 'when user receives approval notifications' do
      before do
        ResqueSpec.reset!
        put :approve, :id => doc.id, :global_rubric => doc.global_rubric.link, :rubric => doc.rubric.link
      end

      it 'sends email' do
        Mailer.should have_queued(
          'UserMailer',
          :approval_notification,
          'Doc',
          doc.id
        )
      end
    end
  end

  describe 'ad_codes' do
    let!(:site_ad_code) { create :ad_code, :ad_section => @site, :banner_type => 'horizontal_top', :site => @site }
    let!(:ad_code) { create :ad_code, :ad_section => site_section, :banner_type => 'horizontal_top', :site => @site }
    let!(:global_rubric_ad_code) { create :ad_code, :ad_section => global_rubric, :banner_type => 'horizontal_top', :site => @site }
    let!(:rubric_ad_code) { create :ad_code, :ad_section => doc_rubric, :banner_type => 'horizontal_top', :site => @site }

    before(:each) do
      controller.stub(:set_no_banners)
    end

    it 'should display right ad code for global_rubric' do
      get :index, :global_rubric => global_rubric.link
      assigns(:ad_codes)['horizontal_top'].should have_content(global_rubric_ad_code.code)
    end

    it 'should display right ad code for rubric' do
      get :rubric, :global_rubric => global_rubric.link, :rubric => doc_rubric.link
      assigns(:ad_codes)[:horizontal_top].should have_content(rubric_ad_code.code)
    end

    it 'should display right ad code for show' do
      get :rubric, :global_rubric => global_rubric.link, :rubric => doc_rubric.link, :id => doc.id
      assigns(:ad_codes)[:horizontal_top].should have_content(rubric_ad_code.code)
    end
  end
end
