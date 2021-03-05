# encoding:utf-8
require 'spec_helper'

describe 'Main page with external docs' do
  let!(:site) { create :prague_site }
  let!(:external_doc_rubric) { create :external_doc_rubric, site: site }
  let!(:main_block) { create :main_block, :external_doc, site: site }
  let!(:main_block_rubric) { create :main_block_rubric, main_block: main_block, rubric: external_doc_rubric }

  def have_main_block
    have_css('div.l-page__columns-line aside.l-page__column section div.b-news div.info')
  end

  before(:each) do
    Rails.cache.clear
  end

  context 'when there are some main docs in main block' do
    context 'when approved' do
      let!(:external_doc) { create :external_doc, :approved, :main, rubric: external_doc_rubric, site: site }

      before(:each) do
        visit root_path
      end

      it 'shows to external_doc' do
        page.should have_link(external_doc.title, external_doc.url)
        page.should have_xpath("//img[@src=\"#{external_doc.image.medium.url}\"]")
      end

      it 'shows to main_block url' do
        page.should have_link(main_block.title, main_block.path)
        page.should have_main_block
      end
    end

    context 'when not approved' do
      let!(:external_doc) { create :external_doc, :main, rubric: external_doc_rubric, site: site }

      before(:each) do
        visit root_path
      end

      it 'does not show external_doc' do
        page.should_not have_link(external_doc.title, external_doc.url)
        page.should_not have_xpath("//img[@src=\"#{external_doc.image.medium.url}\"]")
      end

      it 'does not show main_block' do
        page.should_not have_link(main_block.title, main_block.path)
        page.should_not have_main_block
      end
    end
  end

  context 'when no external docs in main block' do
    before(:each) do
      Rails.cache.clear
      visit root_path
    end

    it 'does not show main block' do
      page.should_not have_link(main_block.title, main_block.path)
      page.should_not have_main_block
    end
  end
end
