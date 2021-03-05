# encoding:utf-8
require 'spec_helper'

describe 'Doc page' do
  let!(:site) { create :prague_site }
  let!(:global_rubric) { create :doc_global_rubric, link: 'news', site: site }
  let!(:tag) {create(:tag, site: site)}
  let!(:doc_rubric) { create :doc_rubric, :site => site, global_rubric: global_rubric }
  let!(:doc) { create :doc, :approved, rubric: doc_rubric, site: site }
  let!(:docs_section) { create :section, :controller => 'docs' }
  let!(:site_section) { create :site_section, :site => site, :section => docs_section}

  before do
    doc.tag_list = "#{tag.name}"
    doc.save
    Rails.cache.clear
    visit doc.url
  end

  context 'with similar docs' do
    let!(:similar_doc) { create :doc, approved: true, site: site, rubric: doc_rubric}

    before(:each) do
      similar_doc.tag_list = "#{tag.name}"
      similar_doc.save
      similar_doc.reload
      Rails.cache.clear
      visit doc.url
      doc.reload
    end

    it 'contains have similar posts block' do
      page.should have_content('Читайте также')
    end

    it 'has 1 similar post' do
      find('div.read-more').all('div.b-items-list__item').size.should eq(1)
    end
  end

  context 'without similar docs' do
    it 'does not contain have link to login' do
      page.should_not have_content('Читайте также')
    end
  end
end
