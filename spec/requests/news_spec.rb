# encoding:utf-8
require 'spec_helper'

describe 'News page' do
  let(:site) { create :prague_site }
  let(:current_user) { create :user }
  let!(:doc_global_rubric) { create :doc_global_rubric, site: site, link: 'news' }
  let!(:doc_rubric) { create :doc_rubric, :site => site, global_rubric: doc_global_rubric }
  let!(:news_section) { create :section, :controller => 'docs' }
  let!(:site_section) { create :site_section, :site => site, :section => news_section }
  let!(:doc) { create :doc, :approved, :site => site, :rubric => doc_rubric }

  before do
  end

  context 'when user is editor' do
    let!(:site_admin) { create :site_editor, :site => site, :user => current_user }
    let!(:permission) { create :permission, :site_admin => site_admin, :section => news_section }

    before do
      login current_user
      visit "/news"
    end

    it 'contains links to new articles' do
      page.should have_link('От редакции')
    end
  end

  context 'when user is reader' do
    before do
      visit "/news"
    end

    it 'does not contains links to new articles' do
      page.should_not have_link('От юзеров')
      page.should_not have_link('От редакции')
    end

    it 'contains link to news rubric' do
      page.should have_link(doc.rubric.title)
    end
  end
end
