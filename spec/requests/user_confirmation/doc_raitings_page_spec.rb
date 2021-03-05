# encoding:utf-8
require 'spec_helper'

describe 'doc raitings confirmation' do
  let!(:site) { create :prague_site }
  let!(:docs_section) { create :section, controller: 'docs' }
  let!(:doc_global_rubric) { create :doc_global_rubric, site: site }
  let!(:site_section) { create :site_section, site: site, section: docs_section }
  let!(:doc_rubric) { create :doc_rubric, site: site, global_rubric: doc_global_rubric }
  let!(:doc) { create :doc, :approved, site: site, rubric: doc_rubric }

  before do
    Rails.cache.clear
  end

  context 'user not logged_in' do
    it 'redirects to loggin page', js: true do
      Rails.cache.clear
      visit_with_port(doc.url)
      find(:css, 'a.rating-action-plus').click
      current_path.should eq(account_login_path)
    end
  end

  context 'user not confirmed' do
    let!(:current_user) { create :user, :not_confirmed, site: site }

    before do
      login current_user
      visit_with_port(doc.url)
    end

    it 'redirects to reconfirm page', js: true do
      find(:css, 'a.rating-action-plus').click
      current_path.should eq(user_not_confirm_path(current_user.subdomain))
    end
  end

  context 'user confirmed' do
    let!(:current_user) { create :user, site: site }

    before do
      login current_user
      visit_with_port(doc.url)
    end

    it 'increments raiting', js: true do
      find(:css, 'a.rating-action.plus').click
      page.should have_selector('div.rating-actions.disabled')
      raiting = page.find(:css, 'h5#rating_value_article').text
      raiting.should eq("1")
    end
  end
end
