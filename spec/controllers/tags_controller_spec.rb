# encoding: utf-8
require 'json'
require 'spec_helper'

describe TagsController do

  let(:tag) { create :tag, :site => @site}
  let!(:doc_global_rubric) { create :doc_global_rubric, site: @site, link: 'news' }
  
  before(:each) do
    @request.host = @site.domain
  end

  describe 'GET autocomplete' do
    context 'when user authorized' do
      let(:response_json) { JSON.parse response.body }
      before do
        admin_login
        get :autocomplete, :term => tag.name[0..1]
      end

      it 'should be success' do
        response.should be_success
      end

      it 'should return json with tag' do
        response_json.size.should eq(1)
        response_json.first['id'].should eq(tag.id)
      end
    end

    context 'when user not authorized' do
      it 'should not be success' do
        get :autocomplete, :term => tag.name[0..1]
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe 'GET #show' do
    let!(:new_tag) { create(:tag, name: 'товарищ', link: 'comrade', site: @site) }
    
    it 'renders show' do
      get :show, id: new_tag.link
      expect(response).to be_success
    end
  end

end
