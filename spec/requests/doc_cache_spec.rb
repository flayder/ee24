# encoding:utf-8
require 'spec_helper'

describe 'Doc cache' do
  let!(:site) { create :prague_site }
  let!(:current_user) { create :user }
  let!(:news_section) { create :section, :controller => 'docs' }
  let!(:doc_global_rubric) { create :doc_global_rubric, site: site }
  let!(:site_section) { create :site_section, :site => site, :section => news_section }
  let!(:doc_rubric) { create :doc_rubric, :site => site, global_rubric: doc_global_rubric }
  let!(:doc) { create :doc, :approved, :site => site, :rubric => doc_rubric }

  before do
    Rails.cache.clear
    visit doc.url
  end

  context 'not for site_admin' do
    it 'caches doc' do
      redis = Redis.new(db: 3)
      Rails.cache.read("views/#{doc.redis_cache_key(:show)}").should be
    end
  end

  context 'for site_admin' do
    let!(:site_admin) { create :site_admin, :user => current_user, :site => site }

    it 'does not cache doc' do
      Rails.cache.read(doc.redis_cache_key(:show)).should be_nil
    end
  end
end
