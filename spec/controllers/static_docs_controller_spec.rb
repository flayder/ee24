# encoding : utf-8
require 'spec_helper'

describe StaticDocsController do

  let(:static_doc) { create :active_static_doc, :site => @site}

  before(:each) do
    @request.host = @site.domain
  end

  describe 'GET show' do
    before(:each) do
      get :show, :id => static_doc.link
    end

    it 'assing @doc' do
      assigns(:doc).should eq(static_doc)
    end

    it 'assing @broads' do
      assigns(:broads).should eq([static_doc.title])
    end

    it 'should render index' do
      response.should be_success
      response.should render_template('static_docs/show')
    end
  end
end
