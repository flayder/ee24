# encoding : utf-8
require 'spec_helper'

describe Admin::DictionaryRubricsController do

  let!(:admin) { create :site_admin, :site => @site }
  let!(:dictionary_rubrics) do
    FactoryGirl.create_list(
      :dictionary_rubric,
      10,
      :site => @site
    )
  end

  before(:each) do
    @request.host = @site.domain
    login admin.user
  end

  describe 'GET index' do
    before :each do
      get :index
    end

    it 'assigns @dictionary_rubrics' do
      assigns(:dictionary_rubrics).should =~ DictionaryRubric.page(1)
    end

    it 'renders the index template' do
      response.should be_success
      response.should render_template('index')
    end
  end

  describe 'GET new' do
    before :each do
      get :new
    end

    it 'assigns @dictionary_rubric' do
      assigns(:dictionary_rubric).class.should == DictionaryRubric
      assigns(:dictionary_rubric).should be_new_record
    end

    it 'renders the new template' do
      response.should be_success
      response.should render_template('new')
    end
  end

  describe 'GET edit' do
    let(:dictionary_rubric) { dictionary_rubrics.first }

    before :each do
      get :edit, :id => dictionary_rubric.id
    end

    it 'assigns @dictionary_rubric' do
      assigns(:dictionary_rubric).should eq(dictionary_rubric)
    end

    it 'renders the edit template' do
      response.should be_success
      response.should render_template('edit')
    end
  end

  describe 'DELETE destroy' do
    let(:dictionary_rubric) { dictionary_rubrics.first }

    it 'should delete @dictionary_rubric' do
      lambda {
        delete :destroy, :id => dictionary_rubric.id
      }.should change(DictionaryRubric, :count).by(-1)
    end
  end

  describe 'PUT update' do
    let(:dictionary_rubric) { dictionary_rubrics.first }

    before :each do
      put :update, :id => dictionary_rubric.id, :person => dictionary_rubric.attributes
    end

    it 'should update @dictionary_rubric' do
      dictionary_rubric.reload.attributes.should eq(dictionary_rubric.attributes)
    end

    it 'should redirect to index' do
      response.should redirect_to(:action => :index, :notice => 'Словарная рубрика успешно обновлена')
    end
  end

  describe 'POST create' do
    let(:dictionary_rubric_attrs) do
      attributes_for(
        :dictionary_rubric,
        :site_id => @site.id
      )
    end

    it 'should delete @dictionary_rubric' do
      lambda {
        post :create, :dictionary_rubric => dictionary_rubric_attrs
      }.should change(DictionaryRubric, :count).by(1)
    end
  end
end
