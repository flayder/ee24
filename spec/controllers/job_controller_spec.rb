# encoding: utf-8
require 'spec_helper'
describe JobController do
  let!(:current_user) { create :user }
  let!(:vacancy) { create(:vacancy) }
  let!(:job_section) { create :section, :controller => 'job' }
  let!(:job_site_section) { create :site_section, :section => job_section, :site => @site}
  let!(:doc_global_rubric) { create :doc_global_rubric, site: @site, link: 'job' }
  let!(:doc_rubric) { create :doc_rubric, :site => @site, global_rubric: doc_global_rubric }
  let!(:doc_rubric) { create :doc_rubric, :link => 'career', :site => @site, global_rubric: doc_global_rubric }

  before(:each) do
    @request.host = @site.domain
  end

  it "should render index" do
    get :index, :type => 'vacancy'
    response.should be_success
    response.should render_template("job/index")
  end

  it 'should redirect to login page on new action for not logged in user' do
    get :new, :type => 'vacancy'
    response.should be_redirect
  end

  it 'should render new action for logged in user' do
    user_login
    get :new, :type => 'vacancy'
    response.should be_success
    response.should render_template("job/new")
  end

  it 'should redirect when trying to edit for not logged in' do
    get :edit, :type => 'vacancy', :id => vacancy.id
    expect(response).to redirect_to(root_url)
  end

  it 'should render edit  for owner' do
    user_login current_user
    vacancy = create(:vacancy, :user => current_user)
    get :edit, :type => 'vacancy', :id => vacancy.id

    response.should be_success
    response.should render_template('edit')
  end

  it 'should render template for edit for owner if vacancy is not approved' do
    user_login current_user
    vacancy = create(:vacancy, :user => current_user, :approved => false)
    get :edit, :type => 'vacancy', :id => vacancy.id

    response.status.should == 200
    response.should render_template('edit')
  end

  it 'should render edit for for admin' do
    admin_login
    get :edit, :type => 'vacancy', :id => vacancy.id

    response.should be_success
    response.should render_template('edit')
  end

  it 'should render 403 when trying to edit for not owner' do
    user_login
    vacancy = create(:vacancy)

    get :edit, :type => 'vacancy', :id => vacancy.id
    expect(response).to redirect_to(root_url)
  end


  describe JobController, 'creating vacancy' do
    before(:each) do
      user_login
      vacancy = build(:vacancy)
      @attrs = vacancy.attributes
      @attrs[:profession_ids] = vacancy.profession_ids
    end

    it 'should create vacancy' do
      lambda do
        post :create, :vacancy => @attrs, :type => 'vacancy'
      end.should change(Vacancy, :count).by(1)
      response.should redirect_to(:action => :index, :type => 'vacancy')
      flash[:notice].should eql('Вакансия появится на сайте после подтверждения администратором')
    end

    it 'should render new action when creating with invalid params' do
      @attrs['title'] = ''
      lambda do
        post :create, :vacancy => @attrs, :type => 'vacancy'
      end.should_not change(Vacancy, :count)
      response.should render_template('new')
    end

    it 'creates new region city when needed' do
      region = create(:region)
      @attrs['region_city_id'] = nil
      @attrs['region_id'] = region.id
      @attrs['region_city_title'] = 'new city title'
      expect{
        post :create, :vacancy => @attrs, :type => 'vacancy'
      }.to change(RegionCity, :count).by(1)
    end
  end

  describe JobController, 'creating resume' do
    before { skip 'Resume functionality was disabled' }

    let(:current_user) { create :user }
    before(:each) do
      resume = build(:resume)
      @attrs = resume.attributes
      @attrs[:profession_ids] = resume.profession_ids
    end

    it 'should create resume' do
      user_login
      lambda do
        post :create, :resume => @attrs, :type => 'resume'
      end.should change(Resume, :count).by(1)
      response.should redirect_to(:action => :index, :type => 'resume')
      flash[:notice].should eql('Резюме появится на сайте после подтверждения администратором')
    end

    it 'should create user resume' do
      user_login current_user
      post :create, :resume => @attrs, :type => 'resume'
      assigns[:job_item].user_id.should be_true
      assigns[:job_item].user_id.should == current_user.id
    end

    it 'should create not approved resume' do
      user_login
      post :create, :resume => @attrs, :type => 'resume'
      assigns[:job_item].approved.should be_false
    end

    it 'should create approved resume for admin' do
      admin_login
      post :create, :resume => @attrs.merge(:approved => true), :type => 'resume'
      assigns[:job_item].approved.should be_true
    end

  end

  describe JobController, 'deleting vacancy' do

    let!(:current_user) { create :user }
    let!(:vacancy) { create :vacancy, :user => current_user }
    before(:each) do
      user_login current_user
    end

    it 'should delete vacancy' do
      lambda do
        delete :destroy, :id => vacancy.id, :type => 'vacancy'
      end.should change(Vacancy, :count).by(-1)
      response.should redirect_to(:action => :index, :type => 'vacancy')
    end

    it 'should delete not approved vacancy' do
      vacancy.update_attribute(:approved, false)
      vacancy.reload

      lambda do
        delete :destroy, :id => vacancy.id, :type => 'vacancy'
      end.should change(Vacancy, :count).by(-1)
      response.should redirect_to(:action => :index, :type => 'vacancy')
    end

  end

  describe JobController, 'deleting resume (admin)' do
    before(:each) do
      admin_login
    end

    it 'should delete resume for admin' do

      resume = create(:resume)

      lambda do
        delete :destroy, :id => resume.id, :type => 'resume'
      end.should change(Resume, :count).by(-1)
      response.should redirect_to(:action => :index, :type => 'resume')
    end

    it 'should delete not approved resume for admin' do
      admin_login
      resume = create(:resume, :approved => false)
      lambda do
        delete :destroy, :id => resume.id, :type => 'resume'
      end.should change(Resume, :count).by(-1)
      response.should redirect_to(:action => :index, :type => 'resume')
    end
  end


  describe JobController, 'updating vacancy' do
    let(:current_user) { create :user }
    let(:vacancy) { create(:vacancy, :approved, :user => current_user) }

    it 'should set vacancy not approved after update' do
      user_login current_user
      params = vacancy.attributes
      params[:profession_ids] = vacancy.professions.map(&:id)
      params.delete('approved')

      lambda do
        put :update, :vacancy => params, :id => vacancy.id, :type => 'vacancy'
      end.should change(Vacancy.approved, :count).by(-1)

      response.should redirect_to(:action => :index, :type => 'vacancy')
      flash[:notice].should eql('Обновление прошло успешно. Вакансия появится на сайте после подтверждения администратором')
    end
  end

  describe 'GET show' do
    context 'for owner' do
      let!(:vacancy) { create(:vacancy, :user => current_user) }

      before(:each) do
        user_login current_user
      end

      it 'renders vacancy for owner' do
        get :show, :id => vacancy.id, :type => 'vacancy'
        response.should be_success
      end

      it 'increases page views' do
        $page_views_redis.flushdb
        expect {
          get :show, :id => vacancy.id, :type => 'vacancy'
        }.to change { vacancy.reload.redis_page_views.to_i }.by(2)
      end
    end

    context 'not for owner' do
      let!(:vacancy) { create(:vacancy) }

      it 'renders 404 for unapproved vacancy' do
        get :show, :id => vacancy.id, :type => 'vacancy'
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
