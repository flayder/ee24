# encoding:utf-8
require 'spec_helper'

describe 'Doc' do
  let!(:site) { create :prague_site }
  let!(:news_section) { create :section, controller: 'docs' }
  let!(:site_section) { create :site_section, site: site, section: news_section }
  let!(:doc_rubric) { create :doc_rubric, site: site, global_rubric: doc_global_rubric }
  let!(:doc_global_rubric) { create :doc_global_rubric, site: site }
  let(:doc_fields) { attributes_for(:doc) }
  let!(:current_user) { create :user }

  before do
    Rails.cache.clear
  end

  context 'when user' do
    let(:doc) { Doc.last }

    before do
      login current_user
      visit_with_port("/#{doc_global_rubric.link}/new")
    end

    it 'creates proper doc', js: true do
      within 'form#new_doc' do
        within '#doc_doc_rubric_id' do
          find(:css, "option[value='#{doc_rubric.id}']").select_option
        end
        fill_in 'doc_title', with: doc_fields[:title]
        attach_file("doc_photos_attributes_0_image", fixture_file_path("ava.jpg"))
        fill_in 'doc_annotation', with: doc_fields[:annotation]
        fill_in_ckeditor 'doc_text', with: doc_fields[:text]
        find(:xpath, 'input[@type="submit"]').click
      end

      page.current_path.should eq("/#{doc_global_rubric.link}")

      Doc.should have(1).item
      doc.should_not be_approved
      doc.should be_main
      doc.site.should eq(site)
      doc.title.should eq(doc_fields[:title])
      doc.text.should include(doc_fields[:text])
      doc.annotation.should eq(doc_fields[:annotation])
      doc.rubric.should eq(doc_rubric)
    end
  end

  context 'when editor' do
    let!(:site_admin) { create :site_editor, site: site, user: current_user }
    let!(:rubric_permission) { create :rubric_permission, rubric: doc_rubric, site_admin: site_admin }
    let(:doc) { Doc.last }
    let(:created_at) { rand(1.year).ago.change(sec: 0) }
    let!(:tag) {create(:tag, site: site)}
    let!(:tag1) {create(:tag, site: site)}

    before do
      login current_user
      visit_with_port("/#{doc_global_rubric.link}/new")
    end

    it 'creates doc', js: true do
      within 'form#new_doc' do
        within '#doc_doc_rubric_id' do
          find(:css, "option[value='#{doc_rubric.id}']").select_option
        end
        fill_in 'doc_title', with: doc_fields[:title]
        attach_file("doc_photos_attributes_0_image", fixture_file_path("ava.jpg"))
        fill_in 'doc_annotation', with: doc_fields[:annotation]
        fill_in_ckeditor 'doc_text', with: doc_fields[:text]
        fill_in 'doc_tag_list', with: ("#{tag.name}, #{tag1.name}")
        check('doc_approved')
        check('doc_main')
        check('doc_no_watermark')
        check('doc_pictureless')
        check('doc_not_in_rss')
        within '#doc_created_at_3i' do
          find(:css, "option[value='#{created_at.day}']").select_option
        end
        within '#doc_created_at_2i' do
          find(:css, "option[value='#{created_at.month}']").select_option
        end
        within '#doc_created_at_1i' do
          find(:css, "option[value='#{created_at.year}']").select_option
        end
        within '#doc_created_at_4i' do
          find(:css, "option[value='#{created_at.hour.to_s.rjust(2, '0')}']").select_option
        end
        within '#doc_created_at_5i' do
          find(:css, "option[value='#{created_at.min.to_s.rjust(2, '0')}']").select_option
        end
        find(:xpath, 'input[@type="submit"]').click
      end

      page.current_path.should eq("/#{doc_global_rubric.link}")

      Doc.should have(1).item
      doc.should be_approved
      doc.should be_main
      doc.should be_no_watermark
      doc.should be_pictureless
      doc.should be_not_in_rss
      doc.site.should eq(site)
      doc.title.should eq(doc_fields[:title])
      doc.text.should include(doc_fields[:text])
      doc.annotation.should eq(doc_fields[:annotation])
      doc.rubric.should eq(doc_rubric)
      doc.created_at.should eq(created_at)
    end
  end
end
