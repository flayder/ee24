# encoding:utf-8
require 'spec_helper'

describe 'Moderator' do
  let!(:site) { create :prague_site }
  let!(:current_user) { create :user }
  let!(:news_section) { create :section, :controller => 'docs' }
  let!(:site_section) { create :site_section, :site => site, :section => news_section }

  let!(:doc_global_rubric) { create :doc_global_rubric, site: site, link: 'news' }
  let!(:doc_rubric) { create :doc_rubric, :site => site, global_rubric: doc_global_rubric }
  let!(:doc) { create :doc, :approved, :site => site, :rubric => doc_rubric, :user => current_user }

  let!(:site_moderator) { create :site_moderator, :site => site, :user => current_user }

  let!(:another_doc_rubric) { create :doc_rubric, :site => site, global_rubric: doc_global_rubric }
  let!(:another_doc) { create :doc, :approved, :site => site, :rubric => doc_rubric }
  let!(:another_rubric_doc) { create :doc, :site => site, :rubric => another_doc_rubric }

  before do
    login current_user
  end

  context 'with rubric permissions' do
    let!(:rubric_permission) { create :rubric_permission, :rubric => doc_rubric, :site_admin => site_moderator }
    let(:unapproved_doc) { create :doc, :site => site, :rubric => doc_rubric, :user => current_user }

    context 'on rubric page' do
      before { visit "/news/#{doc_rubric.link}" }

      it 'sees articles' do
        find('div.b-items-list').all('div.doc.b-items-list__item').should have(2).items
      end

      it 'sees link to edit and delete for his article' do
        within("div#doc_#{doc.id}") do
          page.should_not have_link('Редактировать')
          page.should_not have_link('Удалить')
        end
      end

      it 'sees link to edit and delete for anothers article' do
        within("div#doc_#{another_doc.id}") do
          page.should_not have_link('Редактировать')
          page.should_not have_link('Удалить')
        end
      end

      it 'contains links to new articles' do
        page.should_not have_link('От юзеров')
        page.should_not have_link('От редакции')
      end
    end

    context 'on article page' do
      context 'when approved' do
        before { visit "/news/#{doc_rubric.link}/#{another_doc.id}" }

        it 'sees link to edit and delete edit article' do
          page.should_not have_link('редактировать')
          page.should_not have_link('подтвердить')
          page.should_not have_link('удалить')
        end
      end

      context 'when not approved' do
        before { visit "/news/#{doc_rubric.link}/#{unapproved_doc.id}" }

        it 'sees link to edit and delete article' do
          page.should have_link('редактировать')
          page.should have_link('удалить')
        end

        it 'does not see link to approve' do
          page.should_not have_link('подтвердить')
        end
      end
    end

    context 'when creates article' do
      before { visit '/docs/new' }

      it 'see rich textarea', :js => true do
        pending 'FIX Test fails when run all tests and passes alone.'
        page.should have_css('span#cke_doc_text')
      end

      it 'does not see approved checkbox' do
        page.should_not have_css('input#doc_approved')
      end
    end
  end

  context 'without rubric permissions' do
    context 'on rubric page' do
      before { visit "/news/#{doc_rubric.link}" }

      it 'sees articles' do
        find('div.b-items-list').all('div.doc.b-items-list__item').should have(2).items
      end

      it 'does not see link to edit and delete article' do
        within("div#doc_#{doc.id}") do
          page.should_not have_link('Редактировать')
          page.should_not have_link('Удалить')
        end
      end

      it 'contains links to new articles' do
        page.should_not have_link('От юзеров')
        page.should_not have_link('От редакции')
      end
    end

    context 'on article page' do
      before { visit "/news/#{another_doc_rubric.link}/#{another_rubric_doc.id}" }

      it 'does not see link to edit article' do
        page.should_not have_link('редактировать')
        page.should_not have_link('подтвердить')
        page.should_not have_link('удалить')
      end
    end

    context 'when edit article' do
      before { visit "/news/#{another_doc.id}/edit" }

      it 'does not see rich textarea' do
        page.should_not have_css('span#cke_doc_text')
      end

      it 'does not see approved checkbox' do
        page.should_not have_css('input#doc_approved')
      end
    end

    context 'when creates article' do
      before { visit "/news/new" }

      it 'does not see rich textarea' do
        page.should_not have_css('span#cke_doc_text')
      end

      it 'does not see approved checkbox' do
        page.should_not have_css('input#doc_approved')
      end
    end
  end
end
