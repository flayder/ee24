require 'spec_helper'

describe 'Observer' do
  let!(:site) { create :prague_site }

  let!(:comment_section) { create :section, :controller => 'comments' }
  let!(:comments_site_section) { create :site_section, :site => site, :section => comment_section }

  let!(:doc_global_rubric) { create :doc_global_rubric, site: site, link: 'news' }

  let!(:current_user) { create :user }
  let!(:site_observer) { create :site_observer, :site => site, :user => current_user }
  let!(:doc_rubric) { create :doc_rubric, :site => site, global_rubric: doc_global_rubric }
  let!(:news_section) { create :section, :controller => 'docs' }
  let!(:site_section) { create :site_section, :site => site, :section => news_section }
  let!(:doc) { create :doc, :approved, :site => site, :rubric => doc_rubric, :user => current_user }
=begin
  context 'on observed site' do
    before do
      login current_user
      visit "/news/#{doc_rubric.link}/#{doc.id}"
    end

    it 'sees ip address' do
      page.should have_content(ip.ip)
    end
  end

  context 'not on observered site' do
    let!(:another_site_observer) { create :site_observer }

    before do
      login another_site_observer.user
      visit "/news/#{doc_rubric.link}/#{doc.id}"
    end

    it 'does not see ip address' do
      page.should_not have_content(ip.ip)
    end
  end
=end
end
