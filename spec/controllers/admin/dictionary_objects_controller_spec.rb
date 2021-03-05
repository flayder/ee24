# encoding : utf-8
require 'spec_helper'

describe Admin::DictionaryObjectsController do

  let!(:admin) { create :site_admin, :site => @site }
  let!(:dictionary) { create :dictionary, :site => @site }
  let!(:dictionary_rubric) { create :dictionary_rubric, :site => @site, :dictionary => dictionary }
  let!(:dictionary_objects) do
    FactoryGirl.create_list(
      :dictionary_object,
      10,
      :site => @site,
      :rubric => dictionary_rubric
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

    it 'assigns @dictionary_objects' do
      assigns(:dictionary_objects).should =~ DictionaryObject.page(1)
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

    it 'assigns @dictionary_object' do
      assigns(:dictionary_object).class.should == DictionaryObject
      assigns(:dictionary_object).should be_new_record
    end

    it 'renders the new template' do
      response.should be_success
      response.should render_template('new')
    end
  end

  describe 'GET edit' do
    let(:dictionary_object) { dictionary_objects.first }

    before :each do
      get :edit, :id => dictionary_object.id
    end

    it 'assigns @dictionary_object' do
      assigns(:dictionary_object).should eq(dictionary_object)
    end

    it 'renders the edit template' do
      response.should be_success
      response.should render_template('edit')
    end
  end

  describe 'DELETE destroy' do
    let(:dictionary_object) { dictionary_objects.first }

    it 'should delete @dictionary_object' do
      lambda {
        delete :destroy, :id => dictionary_object.id
      }.should change(DictionaryObject, :count).by(-1)
    end
  end

  describe 'PUT update' do
    let(:dictionary_object) { dictionary_objects.first }

    before :each do
      put :update, :id => dictionary_object.id, :person => dictionary_object.attributes
    end

    it 'should update @dictionary_object' do
      dictionary_object.reload.attributes.should eq(dictionary_object.attributes)
    end

    it 'should redirect to index' do
      response.should redirect_to(:action => :index, :notice => 'Словарная статья успешно обновлена')
    end
  end

  describe 'POST create' do
    let(:dictionary_object_attrs) do
      attributes_for(
        :dictionary_object,
        :site_id => @site.id,
        :rubric_id => dictionary_rubric.id
      )
    end

    it 'should delete @dictionary_object' do
      lambda {
        post :create, :dictionary_object => dictionary_object_attrs
      }.should change(DictionaryObject, :count).by(1)
    end
  end
end
