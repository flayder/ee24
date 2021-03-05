# encoding : utf-8
require 'spec_helper'

describe Admin::StaticDocsController do

  let(:admin) { create :site_admin, :site => @site }
  let(:static_doc) { create :static_doc, :site => @site }

  before(:each) do
    @request.host = @site.domain
    login admin.user
  end

  describe 'GET index' do
    before :each do
      get :index
    end

    it 'assigns @static_docs' do
      assigns(:static_docs).should =~ @site.static_docs.page(1)
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

    it 'assigns @static_doc' do
      assigns(:static_doc).class.should == StaticDoc
      assigns(:static_doc).should be_new_record
    end

    it 'renders the new template' do
      response.should be_success
      response.should render_template('new')
    end
  end

  describe 'GET edit' do
    before :each do
      get :edit, :id => static_doc.id
    end

    it 'assigns @static_doc' do
      assigns(:static_doc).should eq(static_doc)
    end

    it 'renders the edit template' do
      response.should be_success
      response.should render_template('edit')
    end
  end

  describe 'DELETE destroy' do
    before :each do
      static_doc.save
    end

    it 'should delete @static_doc' do
      lambda {
        delete :destroy, :id => static_doc.id
      }.should change(StaticDoc, :count).by(-1)
    end
  end

  describe 'PUT update' do
    let(:static_doc_attrs) do
      attributes_for(
        :static_doc,
        :site_id => @site.id
      )
    end

    before :each do
      put :update, :id => static_doc.id, :static_doc => static_doc_attrs
    end

    it 'should update @static_doc' do
      static_doc_attrs.each_pair do |key, value|
        static_doc.reload[key].should eq(value)
      end
    end

    it 'should redirect to index' do
      response.should redirect_to(:action => :index, :notice => 'Статичная страница успешно обновлена.')
    end
  end

  describe 'POST create' do
    let(:static_doc_attrs) do
      attributes_for(
        :static_doc,
        :site_id => @site.id
      )
    end

    it 'should create @static_doc' do
      lambda {
        post :create, :static_doc => static_doc_attrs
      }.should change(StaticDoc, :count).by(1)
    end
  end
end
