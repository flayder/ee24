# encoding : utf-8
require 'spec_helper'

describe Admin::DictionariesController do

  let!(:admin) { create :site_admin, :site => @site }
  let!(:dictionary) { create :dictionary, :site => @site }

  before(:each) do
    @request.host = @site.domain
    login admin.user
  end

  describe 'GET index' do
    before :each do
      get :index
    end

    it 'assigns @dictionaries' do
      assigns(:dictionaries).should eq([dictionary])
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

    it 'assigns @dictionary' do
      assigns(:dictionary).class.should == Dictionary
      assigns(:dictionary).should be_new_record
    end

    it 'renders the new template' do
      response.should be_success
      response.should render_template('new')
    end
  end

  describe 'GET edit' do
    before :each do
      get :edit, :id => dictionary.id
    end

    it 'assigns @dictionary' do
      assigns(:dictionary).should eq(dictionary)
    end

    it 'renders the edit template' do
      response.should be_success
      response.should render_template('edit')
    end
  end

  describe 'DELETE destroy' do
    it 'should delete @dictionary_object' do
      lambda {
        delete :destroy, :id => dictionary.id
      }.should change(Dictionary, :count).by(-1)
    end
  end

  describe 'PUT update' do
    before :each do
      put :update, :id => dictionary.id, :dictionary => dictionary.attributes
    end

    it 'should update @dictionary' do
      dictionary.reload.attributes.should eq(dictionary.attributes)
    end

    it 'should redirect to index' do
      response.should redirect_to(admin_dictionary_path(dictionary))
    end
  end

  describe 'POST create' do
    let(:dictionary_attrs) { attributes_for(:dictionary) }

    it 'should delete @dictionary_object' do
      lambda {
        post :create, :dictionary => dictionary_attrs
      }.should change(Dictionary, :count).by(1)
    end
  end
end
